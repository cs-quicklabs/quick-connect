class Api::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  #prepend_before_action :allow_params_authentication!, only: :create
  #protect_from_forgery with: :null_session
  #protect_from_forgery with: :exception

  respond_to :json
  # POST /api/login
  def create
    binding.irb
    unless request.format == :json
      sign_out
      render status: 406,
             json: { message: "JSON requests only." } and return
    end
    if (!params[:api_user][:email].nil? && !params[:api_user][:password].nil?)
      @api_user ||= User.find_by(email: params[:api_user][:email].downcase)
      if @api_user && @api_user.valid_password?(params[:api_user][:password])
        if !@api_user.confirmed?
          render json: { success: false, message: "You have to confirm your email address before continuing." } and return
        end
      else
        render json: { success: false, message: "Email or password is incorrect." } and return
      end
    end
    if @api_user.permission == "false"
      render json: { success: false, message: "Your account is deactivated." } and return
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
    revoke_token(@api_user)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(@api_user))
    yield if block_given?
    respond_to_on_destroy
  end

  def revoke_token(user)
    user.update_column(:jti, generate_jti)
  end

  def generate_jti
    SecureRandom.uuid
  end

  private

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def revoke_token(user)
    user.update_column(:jti, generate_jti)
  end

  def generate_jti
    SecureRandom.uuid
  end

  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.json { render json: { success: true, message: "Logged out successfully." } }
    end
  end
end
