class Api::PasswordsController < Devise::PasswordsController
  protect_from_forgery with: :null_session

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    yield resource if block_given?
    if successfully_sent?(resource)
      render json: { success: true, message: "Password reset instructions have been sent to your email address." }
    else
      render json: { success: false, message: resource.errors.full_messages.first }
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
