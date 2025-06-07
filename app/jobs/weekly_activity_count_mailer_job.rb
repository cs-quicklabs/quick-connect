class WeeklyActivityCountMailerJob < ApplicationJob
  def perform
    accounts = Account.includes(:owner).all
    accounts.each do |account|
      ActsAsTenant.current_tenant = account
      if !account.owner.nil? && account.owner.email_enabled?
        added_contacts = account.contacts.where("created_at >= ?", 1.week.ago)
        pending_followups = account.owner.follow_ups
        if added_contacts.size > 0 or pending_followups.last.size > 0
          WeeklyActivityMailer.with(user: account.owner, added_contacts: added_contacts, pending_followups: pending_followups.last).weekly_activity.deliver_now
        end
      end
    end
  end
end
