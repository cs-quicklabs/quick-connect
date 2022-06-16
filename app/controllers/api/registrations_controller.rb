class Api::RegistrationsController < Devise::RegistrationsController
  before_action :build_form
  respond_to :json

  def new
    super
  end

  def create
    resource = @form.submit(registration_params)

    if resource.nil? or !resource.persisted?
      show_errors
    else
      respond_to do |format|
        format.json { render json: { success: true, data: resource, message: "You have signed up successfully. However, we could not sign you in because your account is not yet activated." } }
      end
    end
  end

  def build_form
    @form ||= SignUpForm.new
  end

  def show_errors
    respond_to do |format|
      format.json { render json: { message: @form.errors.full_messages.first, success: false } }
    end
  end

  private

  def registration_params
    params.require(:api_user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
