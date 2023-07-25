class SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  def create
    @user ||= User.find_by(email: params[:user][:email].downcase)
    if @user && @user.permission == "false"
      sign_out(@user)
      redirect_to new_user_session_path, alert: "Your account is deactivated." and return
    else
      sign_in(:user, @user)
      flash[:notice] = "Signed in successfully."
      redirect_to after_sign_in_path_for(@user)
    end
  end

  def destroy
    super
  end
end
