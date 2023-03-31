class Contact::ContactActivitiesController < Contact::BaseController
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    authorize [@contact, ContactActivity]
    @contact_activity = ContactActivity.new
    @activities = Activity.all.order(:name)
    @groups = Group.all.where(category: "activity").order(:name)
    @pagy, @contact_activities = pagy_nil_safe(params, @contact.contact_activities.includes(:contact), items: LIMIT)
    render_partial("contact/contact_activities/activity", collection: @contact_activities) if stale?(@contact_activities + [@contact])
  end

  def destroy
    authorize [@contact, @contact_activity]

    @activity = DestroyContactDetail.call(@contact, current_user, @contact_activity).result

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
      if @contact_activity.update(activity_params)
        Event.where(trackable: @contact_activity).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact_activity, partial: "contact/contact_activities/activity", locals: { contact_activity: @contact_activity, contact: @contact }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact_activity, template: "contact/contact_activities/edit", locals: { activity: @contact_activity, contact: @contact }) }
      end
    end
  end

  def create
    authorize [@contact, ContactActivity]
    @contact_activity = AddContactActivity.call(activity_params, current_user, @contact).result
    respond_to do |format|
      if @contact_activity.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:contact_activities, partial: "contact/contact_activities/activity", locals: { contact_activity: @contact_activity, contact: @contact }) +
                               turbo_stream.replace(ContactActivity.new, partial: "contact/contact_activities/form", locals: { contact_activity: ContactActivity.new, contact: @contact, activities: Activity.all.order(:name), groups: Group.all.where(category: "event").order(:name) })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(ContactActivity.new, partial: "contact/contact_activities/form", locals: { contact_activity: @contact_activity, contact: @contact, activities: Activity.all.order(:name), groups: Group.all.where(category: "event").order(:name) }) }
      end
    end
  end

  private

  def activity_params
    params.require(:contact_activity).permit(:title, :body, :activity_id, :user_id, :contact_id, :date)
  end

  def set_activity
    if @contact_activity
      return @contact_activity
    end
    @contact_activity = ContactActivity.find(params[:id])
  end
end
