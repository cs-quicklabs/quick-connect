class UserMailer < ApplicationMailer
  def reset_password(api_user)
    @resource = api_user
    mail(to: @resource.email, subject: "Reset your password", template_path: "mailers/user_mailer")
  end
end
