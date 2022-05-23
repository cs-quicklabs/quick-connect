class Api::ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    super
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
