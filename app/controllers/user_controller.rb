class UserController < BaseController
  before_action :set_user, only: [:update_password, :update, :profile, :password, :preferences, :destroy, :reset, :toggle_email_notifications]
  before_action :find_user, only: [:update_permission]
  before_action :build_form, only: [:update_password, :password]

  def index
    authorize :User
    @title = "Users"
    @users = User.all.order(:first_name).order(created_at: :desc)
  end

  def update_permission
    authorize @user
    redirect_to user_index_path, notice: "User was updated successfully" if @user.update(permission)
  end

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { message: "User was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/profile", locals: { user: @user }) }
      end
    end
  end

  def update_password
    authorize @user
    respond_to do |format|
      if @form.submit(change_password_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { message: "Password was updated successfully", user: @user }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "user/forms/password", locals: { user: @user }) }
      end
    end
  end

  def destroy
    @user.destroy
    redirect_to user_index_path, status: 303, notice: "User has been deleted."
  end

  def profile
    authorize @user
  end

  def password
    authorize @user
  end

  def preferences
    authorize @user
  end

  def reset
    authorize @user
    respond_to do |format|
      if ResetUser.call(@user).result
        format.html { redirect_to user_profile_path, notice: "Your account has been reset successfully." }
      else
        format.html { redirect_to user_profile_path, notice: "Failed to reset your account." }
      end
    end
  end

  def destroy
    authorize @user
    respond_to do |format|
      if DestroyUser.call(@user).result
        signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(@user))
        format.html { redirect_to new_user_registration_path(script_name: ""), notice: "Your account has been deleted successfully." }
      else
        format.html { redirect_to user_profile_path, notice: "Failed to delete user." }
      end
    end
  end

  def toggle_email_notifications
    authorize @user
    @user.update(email_enabled: !@user.email_enabled)
    respond_to do |format|
      format.html { redirect_to user_preferences_path, notice: "Email notifications have been updated.", status: 303 }
      format.turbo_stream { render turbo_stream: turbo_stream.update(@user, partial: "user/forms/preferences", locals: { user: @user }) }
    end
  end

  private

  def set_user
    @user ||= current_user
  end

  def find_user
    if @user
      return @user
    end
    @user ||= User.find(params[:id])
  end

  def build_form
    @form ||= ChangePasswordForm.new(@user)
  end

  def change_password_params
    params.require(:user).permit(:original_password, :new_password, :new_password_confirmation)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
