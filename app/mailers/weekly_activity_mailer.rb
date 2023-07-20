class WeeklyActivityMailer < ApplicationMailer
  def weekly_activity
    @user = params[:user]
    @added_contacts = params[:added_contacts]
    @pending_followups = params[:pending_followups]
    mail(to: @user.email, subject: "Weekly Activities", template_path: "mailers/weekly_activity_mailer")
  end
end
