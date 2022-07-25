class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  #prepend_before_action :allow_params_authentication!, only: :create
  #protect_from_forgery with: :null_session
  #protect_from_forgery with: :exception

  respond_to :json
  # POST /api/login
  def create
    unless request.format == :json
      sign_out
      render status: 406,
             json: { message: "JSON requests only." } and return
    end

    # auth_options should have `scope: :api_user`
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    #respond_with resource, location: after_sign_in_path_for(resource) do |format|
    respond_with resource do |format|
      format.json {
        render json: { success: true,
                       data: { jwt: current_token, user: resource.as_json(only: [:account_id, :email]) },
                       message: "Authentication successful" }
      }
    end
  end

  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to_on_destroy
  end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.json { render json: { success: true, message: "Logged out successfully." } }
    end
  end
end
