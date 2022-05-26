class Api::DashboardController < Api::BaseController
  respond_to :json

  def index
    authorize :dashboard
    @events = @user.events.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
    respond_to do |format|
      format.json { render json: { success: true, data: @events, message: "timeline were successfully retrieved." } }
    end
  end

  def events
    authorize :dashboard, :index?

    @events = @user.events.includes(:eventable, :trackable).order(created_at: :desc).limit(50).decorate
  end
end
