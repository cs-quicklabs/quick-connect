class DashboardController < BaseController
  def index
    authorize :dashboard
    @reminders = current_user.reminders.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    binding.irb
    @upcoming_reminders = @upcoming_reminders.sort_by { |r| r.second[:reminder] }.group_by { |r| r.second[:reminder].beginning_of_month }
    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "PhoneCall" }).order(created_at: :desc).limit(4) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "Conversation" }).order(created_at: :desc).limit(4)
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
