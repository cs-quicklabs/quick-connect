class DailyReminderMailer < ApplicationMailer
  def daily_reminder
    @user = params[:user]
    @reminders = params[:reminders]
    mail(to: @user.email, subject: "Quick Connect: Reminders of the Day", template_path: "mailers/daily_reminder_mailer")
  end
end
