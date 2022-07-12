class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @pagy, @events = pagy_nil_safe(params, Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).decorate, items: 50)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Events were successfully retrieved." }
  end
end
