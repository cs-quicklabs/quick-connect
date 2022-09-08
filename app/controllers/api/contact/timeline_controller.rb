class Api::Contact::TimelineController < Api::Contact::BaseController
  def index
    authorize [:api, @contact, :timeline]
    collection = @contact.events.order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(params, collection.includes(:eventable, :user), items: LIMIT)
    trackable = []
    @events = events_collection
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @events.as_json(:include => [:eventable, :trackable => { :include => { :contact => { only: [:id, :first_name, :last_name] } } }]), message: "Contact timeline" }
  end
end
