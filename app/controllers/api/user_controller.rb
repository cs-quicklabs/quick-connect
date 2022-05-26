class Api::UserController < Api::BaseController
  protect_from_forgery with: :null_session
  before_action :find_user, only: [:update_permission, :destroy]
  before_action :build_form, only: [:update_password, :password]
  respond_to :json

  def update
    authorize @user
    respond_to do |format|
      if @user.update(user_params)
        format.json { render json: { data: @user, sucesss: true, message: "User was updated successfully" } }
      else
        format.json { render json: { sucesss: false, message: @user.errors, data: @user } }
      end
    end
  end

  def update_password
    authorize @user
    respond_to do |format|
      if @form.submit(change_password_params)
        format.json { render json: { data: @user, sucesss: true, message: "password was updated successfully" } }
      else
        format.json { render json: { sucesss: false, message: @user.errors, data: @user } }
      end
    end
  end

  def profile
    authorize @user
    respond_to do |format|
      format.json { render json: { data: @user, sucesss: true, message: "" } }
    end
  end

  def password
    authorize @user
    respond_to do |format|
      format.json { render json: { data: @user, sucesss: true, message: "" } }
    end
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
