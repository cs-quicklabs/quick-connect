class Api::InvitationsController < Devise::InvitationsController
  prepend_before_action :require_no_authentication, only: [:update]
  #before_action :resource_from_invitation_token, only: [:edit, :update]

  def update
    @api_user = User.find_by_invitation_token(accept_invitation_params[:invitation_token],
                                              true)
    if @api_user
      @api_user.update(password: accept_invitation_params[:password])
      self.resource = User.accept_invitation!(accept_invitation_params)
      invitation_accepted = resource.errors.empty?
      yield resource if block_given?
      respond_with resource do |format|
        if invitation_accepted
          resource.after_database_authentication
          format.json {
            render json: { success: true, message: "Password has been reset successfully. Now you can access your account" }
          }
        else
          render json: { success: false, message: resource.errors.full_messages.first }
        end
      end
    else
      render json: { success: false, message: "invalid token" }
    end
  end

  protected

  def current_token
    request.env["warden-jwt_auth.token"]
  end

  def accept_invitation_params
    params.require(:api_user).permit(:password, :password_confirmation, :invitation_token)
  end
end
