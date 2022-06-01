class Api::UserController < Api::BaseController
  before_action :find_user, only: [:update_permission, :destroy]
  before_action :build_form, only: [:update_password, :password]
  respond_to :json

  def update
    authorize @user
    if @user.update(user_params)
      render json: { data: @user, sucesss: true, message: "User was updated successfully" }
    else
      render json: { sucesss: false, message: @user.errors, data: @user }
    end
  end

  def update_password
    authorize @user
    if @form.submit(change_password_params)
      render json: { data: @user, sucesss: true, message: "password was updated successfully" }
    else
      render json: { sucesss: false, message: @form.errors, data: @user }
    end
  end

  def profile
    authorize @user
    render json: { data: @user, sucesss: true, message: "" }
  end

  def password
    authorize @user

    render json: { data: @user, sucesss: true, message: "" }
  end

  private

  def find_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:api_user).permit(:first_name, :last_name)
  end

  def change_password_params
    params.require(:api_user).permit(:original_password, :new_password, :new_password_confirmation)
  end

  def build_form
    @form ||= ChangePasswordForm.new(@user)
  end
end
