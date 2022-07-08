class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @events = Event.all.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
    render json: { success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Events were successfully retrieved." }
  end
end
