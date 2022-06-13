class Api::Contact::TimelineController < Api::Contact::BaseController
  def index
    authorize [:api, @contact, :timeline]
    collection = @contact.events.order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(params, collection.includes(:eventable, :user), items: LIMIT)
    @events = events_collection.decorate
    render json: { success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Contact timeline" }
  end
end
