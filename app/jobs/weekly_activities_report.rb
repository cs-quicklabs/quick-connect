class WeeklyActivityMailerJob < ApplicationJob
  def perform
    accounts = Account.where(email_enabled: true)
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      added_contacts = Contact.all.where("created_at >= ?", 1.week.ago)
      pending_followups = account.owner.follow_ups
      if added_contacts.size > 0 or pending_followups.last.size > 0
        WeeklyActivityMailer.with(user: account.owner, added_contacts: added_contacts, pending_followups: pending_followups.last).weekly_activity.deliver_now
      end
    end
  end
end
