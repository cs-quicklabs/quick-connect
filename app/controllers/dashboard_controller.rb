class DashboardController < BaseController
  def index
    authorize :dashboard
  end

  def events
    authorize :dashboard, :index?
    @events = @user.events.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
  end
end
