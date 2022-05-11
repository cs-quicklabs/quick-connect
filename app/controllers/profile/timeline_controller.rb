class Profile::TimelineController < Profile::BaseController
def index
    authorize [@contact, Timeline]
    collection = @contact.events.order(created_at: :desc)
    @pagy, events_collection = pagy_nil_safe(params, collection.includes(:trackable, :eventable, :user), items: LIMIT)
    @events = events_collection.decorate
    render_timeline("profile/timeline/activity", collection: @events) if stale?(@events)

  end
end  