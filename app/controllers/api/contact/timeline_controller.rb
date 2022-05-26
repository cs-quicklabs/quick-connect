class Api::Contact::TimelineController < Api::Contact::BaseController
  def index
    authorize [@contact, Timeline]
    collection = @contact.events.order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(params, collection.includes(:eventable, :user), items: LIMIT)
    @events = events_collection.decorate
    render json: { success: true, data: { contact: @contact, events: @events }, message: "Timeline was successfully retrieved." }
  end
end
