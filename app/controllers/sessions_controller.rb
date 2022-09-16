class SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user

  def create
    @user ||= User.find_by(email: params[:user][:email].downcase)
    if @user && @user.permission == "false"
      sign_out(@user)
      redirect_to new_user_session_path, alert: "Your account is deactivated." and return
    end
    super
  end
end
