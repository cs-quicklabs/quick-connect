class DashboardController < BaseController
    def index
        authorize :dashboard
        collection = @user.events.order(created_at: :desc)
        @pagy, events_collection = pagy_nil_safe(params, collection.includes(:trackable, :user), items: LIMIT)
        @events = events_collection.decorate
        render_timeline("timeline/activity", collection: @events) if stale?(@events)
    end

end