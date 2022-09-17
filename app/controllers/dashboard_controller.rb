class DashboardController < BaseController
  def index
    authorize :dashboard
    @reminders = Reminder.all.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    @upcoming_reminders = @upcoming_reminders.sort_by { |r| r.second[:reminder] }
    @contacted = Contact.all.available.tracked.includes(:events).where("events.action IN (?)", ["called", "conversation"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
