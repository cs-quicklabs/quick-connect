class Api::PasswordsController < Devise::PasswordsController
  protect_from_forgery with: :null_session

  def create
    api_user = User.find_by(email: params[:api_user][:email])
    if api_user
      api_user.generate_password_token!
      UserMailer.reset_password(api_user).deliver_now
      respond_with({ json: { success: true, message: "Password reset instructions have been sent to your email address." } }, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with({ json: { success: false, message: "Email  does not exist" } }, location: after_sending_reset_password_instructions_path_for(resource_name))
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      if resource.confirmed?
        render json: { success: true, message: "Password has been reset successfully." }
      else
        render json: { success: true, message: "Password has been reset successfully but You have to confirm your email address before continuing. " }
      end
    else
      render json: { success: false, message: resource.errors.full_messages.first }
    end
  end

  private
end
