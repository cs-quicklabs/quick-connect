class DailyReminderMailer < ApplicationMailer
  def daily_reminder
    @user = params[:user]
    @reminder = params[:reminder]
    mail(to: @user.email, subject: "Reminders of the Day", template_path: "mailers/daily_reminder_mailer")
  end
end
