class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
    render json: { success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Events were successfully retrieved." }
  end

  def recents
    authorize [:api, :dashboard]
    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").where(events: { trackable_type: "PhoneCall" }).order(created_at: :desc).limit(4) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").where(events: { trackable_type: "Conversation" }).order(created_at: :desc).limit(4)
    render json: { success: true, data: @contacted.as_json(:include => [:eventable, :trackable]), message: "Recents were successfully retrieved." }
  end

  def favorites
    authorize [:api, :dashboard]
    @pagy, @favorites = pagy_nil_safe(params, Contact.all.favorites, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @favorites, message: "Favorites were successfully retrieved." }
  end
end
