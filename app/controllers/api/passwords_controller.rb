class Api::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({ json: { suceess: true, message: "Password reset instructions have been sent to your email address." } }, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with({ json: { suceess: false, message: resource.errors.full_messages } })
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      if resource.active_for_authentication?
        render json: { suceess: true, message: "Password has been reset successfully." }
      else
        render json: { suceess: true, message: "Password has been reset successfully but You have to confirm your email address before continuing. " }
      end
    else
      render json: { suceess: false, message: resource.errors.full_messages }
    end
  end

  private
end
