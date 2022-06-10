class Api::PasswordsController < Devise::PasswordsController
  def new
    super
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({ json: { suceess: true, message: "Password reset instructions have been sent to your email address." } }, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with({ json: { suceess: false, message: resource.errors } })
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    respond_to do |format|
      if resource.errors.empty?
        format.json { render json: { success: true, data: resource, message: "Your account has been confirmed." } }
      else
        format.json { render json: { message: resource.errors, success: false } }
      end
    end
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource) # In case you want to sign in the user
    your_new_after_confirmation_path
  end
end
