class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @recents = []
    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").where(events: { trackable_type: "PhoneCall" }).order(created_at: :desc).limit(5) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").where(events: { trackable_type: "Conversation" }).order(created_at: :desc).limit(5)
    @reminders = current_user.reminders.where("reminder_date <= ?", Date.today + 60.days)
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming_api
    end
    @upcoming_reminders = @upcoming_reminders.group_by { |r| r.second[:reminder].beginning_of_month }
    @pagy, @events = pagy_nil_safe(params, Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate, items: LIMIT)
    render json: { reminders: @upcoming_reminders, favorites: Contact.all.favorites, recents: @contacted.as_json(:include => [:eventable, :trackable]), pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Events were successfully retrieved." }
  end
end
