class DashboardController < BaseController
  def index
    authorize :dashboard
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
  end
end
