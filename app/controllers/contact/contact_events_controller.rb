class Contact::ContactEventsController < Contact::BaseController
  before_action :set_event, only: %i[show edit update destroy]

  def index
    authorize [@contact, ContactEvent]
    @contact_event = ContactEvent.new
    @life_events = LifeEvent.all.order(:name)
    @groups = Group.all.where(category: "event").order(:name)
    @pagy, @contact_events = pagy_nil_safe(params, @contact.contact_events.includes(:contact).order(date: :desc), items: LIMIT)
    render_partial("contact/contact_events/event", collection: @contact_events) if stale?(@contact_events + [@contact])
  end

  def destroy
    authorize [@contact, @contact_event]
    @event = DestroyContactDetail.call(@contact, current_user, @contact_event).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@contact_event) }
    end
  end

  def edit
    authorize [@contact, @contact_event]
  end

  def update
    authorize [@contact, @contact_event]
    respond_to do |format|
      if @contact_event.update(event_params)
        Event.where(trackable: @contact_event).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact_event, partial: "contact/contact_events/event", locals: { contact_event: @contact_event, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact_event, template: "contact/contact_events/edit", locals: { event: @contact_event, contact: @contact }) }
      end
    end
  end

  def create
    authorize [@contact, ContactEvent]
    @contact_event = AddContactEvent.call(event_params, current_user, @contact, params[:reminder]).result
    @life_events = LifeEvent.all.order(:name)
    @groups = Group.all.where(category: "event").order(:name)
    respond_to do |format|
      if @contact_event.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:contact_events, partial: "contact/contact_events/event", locals: { contact_event: @contact_event, contact: @contact }) +
                               turbo_stream.replace(ContactEvent.new, partial: "contact/contact_events/form", locals: { contact_event: ContactEvent.new, contact: @contact, events: @life_events, groups: @groups })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ContactEvent.new, partial: "contact/contact_events/form", locals: { contact_event: @contact_event, contact: @contact, events: @life_events, groups: @groups }) }
      end
    end
  end

  private

  def event_params
    params.require(:contact_event).permit(:title, :body, :life_event_id, :user_id, :contact_id, :date)
  end

  def set_event
    if @contact_event
      return @contact_event
    end
    @contact_event = ContactEvent.find(params[:id])
  end
end
