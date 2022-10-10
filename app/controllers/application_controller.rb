class ApplicationController < ActionController::Base
  include Pundit

  include Pagy::Backend
  before_action
  respond_to :html
  protect_from_forgery with: :null_session, if: :json_request?
  protect_from_forgery with: :exception, if: :json_request?

  skip_before_action :verify_authenticity_token, if: :json_request?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::InvalidAuthenticityToken,
              with: :invalid_auth_token
  rescue_from Pundit::NotDefinedError, with: :record_not_found
  rescue_from ActiveRecord::InvalidForeignKey, with: :show_referenced_alert
  rescue_from ActsAsTenant::Errors::NoTenantSet, with: :user_not_authorized
  rescue_from ActiveRecord::DeleteRestrictionError, with: :show_referenced_alert
  rescue_from Pagy::OverflowError, with: :record_not_found
  before_action :set_current_user, if: :json_request?
  before_action :set_redirect_path, unless: :user_signed_in?

  etag {
    if Rails.env == "production" or Rails.env == "staging"
      deployment_version
    else
      "development"
    end
  }

  def script_name
    "/#{current_user.account.id}"
  end

  fragment_cache_key do
    "development"
  end

  def deployment_version
    ENV["LATEST_GITHUB_COMMIT"] if Rails.env == "production" or Rails.env == "staging"
  end

  def render_partial(partial, collection:, cached: true)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  def set_redirect_path
    @redirect_path = request.path
  end

  def show_referenced_alert(exception)
    respond_to do |format|
      if http_request?
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: "Unable to Delete Record", message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first.", main_button_visible: false })
        }
      else
        format.json { render json: { success: false, message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first." } }
      end
    end
  end

  def show_delete_confirmation_alert
    show_confirmation_alert("Delete Record", "Are you sure you want to delete this record?")
  end

  def show_confirmation_alert(title, message)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: title, message: message, main_button_visible: true })
      }
    end
  end

  def after_sign_in_path_for(resource)
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    else
      landing_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end

  def user_not_authorized
    if http_request?
      redirect_to(request.referrer || landing_path)
    else
      render json: { success: false, message: "You are not allowed to access this page." }
    end
  end

  def signed_in_root_path(resource)
    landing_path
  end

  def record_not_found
    if http_request?
      user_not_authorized
    else
      render json: { success: false, message: "Record Not Found" }
    end
  end

  def landing_path
    dashboard_path(script_name: script_name)
  end

  def script_name
    "/#{current_user.account.id}"
  end

  def invalid_token
    sign_out(current_user) if current_user
    redirect_to new_user_session_path, alert: "Your session has expired. Please login again."
  end

  def render_timeline(partial, collection:, cached: true)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: partial, formats: [:html], collection: collection, as: :event, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
    end
  end

  private

  def json_request?
    request.format.json?
  end

  def http_request?
    !request.format.json?
  end

  # Use api_user Devise scope for JSON access
  def authenticate_user!(*args)
    super and return unless args.blank?
    if json_request?
      authenticate_api_user!
    elsif header = request.headers["Authorization"]
      authenticate_user
    else
      super
    end
  end

  def authenticate_user
    set_current_user
  end

  def invalid_auth_token
    respond_to do |format|
      format.html {
        redirect_to sign_in_path,
                    error: "Login invalid or expired"
      }
      format.json { head 401 }
    end
  end

  # So we can use Pundit policies for api_users
  def set_current_user
    if header = request.headers["Authorization"]
      header = header.split(" ").last
      key = "aOiynmWWvo17LrD9XTENHp9czMpuw4kH"
      begin
        jwt_payload = JWT.decode(header, key, true, { :algorithm => "HS256" }).first
        @api_user = User.includes(:invited_by).find(jwt_payload["sub"])
      rescue ActiveRecord::RecordNotFound => e
        render json: { success: false, message: "Record no found" }
      rescue JWT::DecodeError => e
        render json: { success: false, message: "unauthorized" }
      end
    end
  end

  def token_verification
    json_request? ? invalid_auth_token : invalid_token
  end
end
