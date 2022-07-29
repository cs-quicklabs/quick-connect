class DashboardController < BaseController
  def index
    authorize :dashboard
    Event.joins(phone_calls: :conversations)
    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").where(events: { trackable_type: "PhoneCall" }).order(created_at: :desc).limit(5) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").where(events: { trackable_type: "Conversation" }).order(created_at: :desc).limit(5)
    @reminders = current_user.reminders.where("reminder_date <= ?", Date.today + 90.days).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    @upcoming_reminders = @upcoming_reminders.group_by { |r| r.second[:reminder].beginning_of_month }
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
