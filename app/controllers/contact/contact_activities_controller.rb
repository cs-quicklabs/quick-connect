class Contact::ContactActivitiesController < Contact::BaseController
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    authorize [@contact, ContactActivity]
    @contact_activity = ContactActivity.new
    @pagy, @contact_activities = pagy_nil_safe(params, @contact.contact_activities.includes(:contact), items: LIMIT)
    render_partial("contact/contact_activities/activity", collection: @contact_activities) if stale?(@relatives)
  end

  def destroy
    authorize [@contact, @contact_activity]

    @relative = DestroyContactDetail.call(@contact, current_user, @contact_activity).result

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@contact_activity) }
    end
  end

  def edit
    authorize [@contact, @contact_activity]
  end

  def update
    authorize [@contact, @contact_activity]

    respond_to do |format|
      if @relative.update(activity_params)
        Event.where(trackable: @contact_activity).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, partial: "contact/contact_activities/activity", locals: { activity: @contact_activity, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, template: "contact/contact_activities/edit", locals: { activity: @contact_activity, contact: @contact }) }
      end
    end
  end

  def create
    authorize [@contact, ContactActivity]
    @relative = AddContactActivity.call(activity_params, current_user, @contact).result
    @relation = Contact.find(relative_params[:contact_id])
    respond_to do |format|
      if @relative.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:contact_activities, partial: "contact/contact_activities/activity", locals: { activity: @contact_activity, contact: @contact }) +
                               turbo_stream.replace(ContactActivity.new, partial: "contact/contact_activities/form", locals: { activity: ContactActivity.new, contact: @contact })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ContactActivity.new, partial: "contact/contact_activities/form", locals: { activity: @contact_activity, contact: @contact }) }
      end
    end
  end

  private

  def activity_params
    params.require(:contact_activity).permit(:title, :body, :activity_id)
  end

  def set_activity
    @relative = ContactActivity.find(params[:id])
  end
end
