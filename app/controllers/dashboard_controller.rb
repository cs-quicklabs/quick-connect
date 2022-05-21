class DashboardController < BaseController
  def index
    binding.irb
    authorize :dashboard
  end

  def events
    authorize :dashboard, :index?

    @events = current_user.events.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
  end
end
