class DailyReminderMailerJob < ApplicationJob
  def perform
    accounts = Account.where("owner_id IS NOT NULL")
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      users = User.where(account_id: account)
      users.each do |user|
        if !user.nil? and user.email_enabled
          reminder_for_user = user.reminders
          todays_reminders = []
          reminder_for_user.each do |reminder|
            todays_reminders += reminder.today
          end
          if todays_reminders.count > 0
            DailyReminderMailer.with(user: user, reminders: todays_reminders).daily_reminder.deliver_now
          end
        end
      end
    end
  end
end
