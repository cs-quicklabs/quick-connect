class Api::Contact::ContactEventsController < Api::Contact::BaseController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    authorize [:api, @contact, ContactEvent]
    @pagy, @contact_events = pagy_nil_safe(params, @contact.contact_events.includes(:contact).order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contact_events.as_json(:include => :life_event), message: "Events fetched successfully" } if stale?(@contact_events + [@contact])
  end

  def destroy
    authorize [:api, @contact, @contact_event]

    @relative = DestroyContactDetail.call(@contact, @api_user, @contact_event).result

    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Event deleted successfully" } }
    end
  end

  def new
    authorize [:api, @contact, ContactEvent]
    render json: { success: true, group: Group.where(category: "event"), data: LifeEvent.all.order(:name), message: "Events fetched successfully" }
  end

  def edit
    authorize [:api, @contact, @contact_event]
    render json: { success: true, data: @contact_event.as_json(:include => :life_event), message: "Events fetched successfully" }
  end

  def update
    authorize [:api, @contact, @contact_event]

    respond_to do |format|
      if @contact_event.update(event_params)
        Event.where(trackable: @contact_event).touch_all
        format.json { render json: { success: true, data: @contact_event.as_json(:include => :life_event), message: "Event updated successfully" } }
      else
        format.json { render json: { success: false, message: @contact_event.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, ContactEvent]
    @event = AddContactEvent.call(event_params, @api_user, @contact, params[:reminder]).result
    respond_to do |format|
      if @event.persisted?
        format.json { render json: { success: true, data: @event.as_json(:include => :life_event), message: "Event created successfully" } }
      else
        format.json { render json: { success: false, message: @event.errors.full_messages.first } }
      end
    end
  end

  private

  def event_params
    params.require(:api_contact_event).permit(:title, :body, :life_event_id, :user_id, :contact_id, :date)
  end

  def set_event
    if @contact_activity
      return @contact_event
    end
    @contact_event = ContactEvent.find(params[:id])
  end
end
