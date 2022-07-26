class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @recents = []
    @contacted = Event.includes(:eventable, :trackable).where(action: ["conversation", "called", "contact_activity"]).order(created_at: :desc).limit(10)
    @contacted.each do |event|
      @recents = event if !event.trackable.nil?
    end
    @pagy, @events = pagy_nil_safe(params, Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate, items: LIMIT)
    render json: { favorites: Contact.all.favorites, recents: @recents.as_json(:include => [:eventable, :trackable]), pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @events.as_json(:include => [:eventable, :trackable]), message: "Events were successfully retrieved." }
  end
end
