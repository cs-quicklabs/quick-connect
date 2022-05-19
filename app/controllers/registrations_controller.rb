class RegistrationsController < Devise::RegistrationsController
  before_action :build_form

  def new
    super
  end

  def create
    resource = @form.submit(registration_params)
    if resource.nil? or !resource.persisted?
      show_errors
    else
      set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"

      respond_to do |format|
        format.json { render json: { success: true, data: resource, status: 200, message: "You have signed up successfully. However, we could not sign you in because your account is not yet activated." } }
        format.html { render :new }
      end
    end
  end

  def show_errors
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("sign_up_form", partial: "devise/registrations/form", locals: { resource: @form }) }
      format.json { render json: { message: @form.errors, success: false, status: 400 } }
    end
  end

  private

  def registration_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def build_form
    @form ||= SignUpForm.new
  end
end
