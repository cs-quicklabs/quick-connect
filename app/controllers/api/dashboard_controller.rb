class Api::DashboardController < Api::BaseController
  def index
    authorize :dashboard, :index?
    @events = @user.events.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
    render json: { success: true, data: @events, message: "Events were successfully retrieved." }
  end
end
