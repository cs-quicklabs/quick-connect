class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization
  respond_to :html, :json
  # protect_from_forgery with: :null_session
  # skip_before_action :verify_authenticity_token, if: :json_request?

  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # rescue_from ActionController::InvalidAuthenticityToken, with: :invalid_token
  # rescue_from ActionController::InvalidAuthenticityToken do
  #   invalid_auth_token if json_request?
  # end
  # rescue_from Pundit::NotDefinedError, with: :record_not_found
  # rescue_from ActiveRecord::InvalidForeignKey, with: :show_referenced_alert
  # rescue_from ActsAsTenant::Errors::NoTenantSet, with: :user_not_authorized
  # rescue_from ActiveRecord::DeleteRestrictionError, with: :show_referenced_alert

  # before_action :set_redirect_path, unless: :user_signed_in?
  before_action :set_current_user do
    set_current_user if user_signed_in?
  end

  etag {
    if Rails.env == "production" or Rails.env == "staging"
      heroku_version
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

  def heroku_version
    ENV["HEROKU_RELEASE_VERSION"] if Rails.env == "production" or Rails.env == "staging"
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

  def json_request?
    request.format.json?
  end

  # Use api_user Devise scope for JSON access
  def authenticate_user!(*args)
    super and return unless args.blank?
    json_request? ? authenticate_api_user! : super
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

  def set_current_user
    if json_request?
      @current_user ||= warden.authenticate(scope: :api_user)
    else
      binding.irb
      current_user = warden.user
    end
  end

  def set_redirect_path
    @redirect_path = request.path
  end

  def show_referenced_alert(exception)
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("modal", partial: "shared/modal", locals: { title: "Unable to Delete Record", message: "This record has been associated with other records in system therefore deleting this might result in unexpected behavior. If you want to delete this please make sure all assosications have been removed first.", main_button_visible: false })
      }
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
    elsif request.referer == new_user_session_url
      super
    else
      landing_path
    end
  end

  def after_sign_out_path_for(resource)
    root_path(script_name: "")
  end

  def user_not_authorized
    redirect_to(request.referrer || landing_path)
  end

  def signed_in_root_path(resource)
    root_path(script_name: script_name)
  end

  def record_not_found
    user_not_authorized
  end

  def landing_path
    root_path(script_name: script_name)
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

  def pagy_nil_safe(params, collection, vars = {})
    pagy = Pagy.new(count: collection.count(:all), page: params[:page], **vars)
    return pagy, collection.offset(pagy.offset).limit(pagy.items) if collection.respond_to?(:offset)
    return pagy, collection
  end
end
