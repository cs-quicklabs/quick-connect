class DashboardController < BaseController
  def index
    authorize :dashboard
    @recents = []
    @contacted = Event.includes(:eventable, :trackable).where(action: ["conversation", "called", "contact_activity"]).order(created_at: :desc).limit(10)
    @contacted.each do |event|
      @recents = event if !event.trackable.nil?
    end
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
