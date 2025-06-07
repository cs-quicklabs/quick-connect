class Contact::TimelineController < Contact::BaseController
  def index
    authorize [@contact, Timeline]
    collection = @contact.events.order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(params, collection.includes(:eventable, :user, :trackable, :account), items: LIMIT)
    @events = events_collection.decorate
    render_timeline("contact/timeline/activity", collection: @events) if stale?(@events + [@contact])
  end
end
