class DashboardController < BaseController
  def index
    authorize :dashboard
    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").where(events: { trackable_type: "PhoneCall" }).order(created_at: :desc).limit(5) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").where(events: { trackable_type: "Conversation" }).order(created_at: :desc).limit(5)
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
