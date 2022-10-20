class Api::UserController < Api::BaseController
  before_action :build_form, only: [:update_password, :password]
  respond_to :json

  def update
    authorize [:api, @api_user]
    if @api_user.update(user_params)
      render json: { data: @api_user, success: true, message: "User was updated successfully" }
    else
      render json: { success: false, message: @api_user.errors.full_messages.first }
    end
  end

  def update_password
    authorize [:api, @api_user]
    if @form.submit(change_password_params)
      render json: { data: @api_user, success: true, message: "Password was updated successfully" }
    else
      render json: { success: false, message: @form.errors.full_messages.first }
    end
  end

  def profile
    authorize [:api, @api_user]
    render json: { success: true, data: @api_user.as_json(:include => [:invited_by]), message: "user profile" } if stale?([@api_user])
  end

  def password
    authorize [:api, @api_user]

    render json: { data: @api_user, success: true, message: "" }
  end

  def update_permission
    authorize [:api, @api_user]
    @api_user.update(email_enabled: !@api_user.email_enabled)
    render json: { data: @api_user, success: true, message: "Enable email notifications successfully updated" }
  end

  def preferences
    authorize [:api, @api_user]
    render json: { success: true, data: @api_user.as_json(:include => [:invited_by]), message: "Show preferences" }
  end

  def reset
    authorize [:api, @api_user]
    respond_to do |format|
      if ResetUser.call(@api_user).result
        format.json { render json: { success: true, message: "User was reset successfully" } }
      else
        format.json { render json: { success: false, message: "Failed to reset user" } }
      end
    end
  end

  def destroy
    authorize [:api, @api_user]
    respond_to do |format|
      if DestroyUser.call(@api_user).result
        format.json { render json: { success: true, message: "User has been deleted successfully." } }
      else
        format.json { render json: { success: false, message: "Failed to delete user" } }
      end
    end
  end

  private

  def find_user
    @api_user ||= User.find(params[:id])
  end

  def user_params
    params.require(:api_user).permit(:first_name, :last_name)
  end

  def change_password_params
    params.require(:api_user).permit(:original_password, :new_password, :new_password_confirmation)
  end

  def build_form
    @form ||= ChangePasswordForm.new(@api_user)
  end
end
