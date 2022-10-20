class Api::Contact::ContactActivitiesController < Api::Contact::BaseController
  before_action :set_activity, only: %i[show edit update destroy]

  def index
    authorize [:api, @contact, ContactActivity]
    @pagy, @contact_activities = pagy_nil_safe(params, @contact.contact_activities.includes(:contact).order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contact_activities.as_json(:include => :activity), message: "Activities fetched successfully" } if stale?(@contact_activities + [@contact])
  end

  def destroy
    authorize [:api, @contact, @contact_activity]

    @relative = DestroyContactDetail.call(@contact, @api_user, @contact_activity).result

    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Activity deleted successfully" } }
    end
  end

  def new
    authorize [:api, @contact, ContactActivity]
    render json: { success: true, group: Group.where(category: "activity"), data: Activity.all.order(:name), message: "Activites fetched successfully" }
  end

  def edit
    authorize [:api, @contact, @contact_activity]
    render json: { success: true, data: @contact_activity.as_json(:include => :activity), message: "Activities fetched successfully" }
  end

  def update
    authorize [:api, @contact, @contact_activity]

    respond_to do |format|
      if @contact_activity.update(activity_params)
        Event.where(trackable: @contact_activity).touch_all
        format.json { render json: { success: true, data: @contact_activity.as_json(:include => :activity), message: "Activity updated successfully" } }
      else
        format.json { render json: { success: false, message: @contact_activity.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, ContactActivity]
    @activity = AddContactActivity.call(activity_params, @api_user, @contact).result
    respond_to do |format|
      if @activity.persisted?
        format.json { render json: { success: true, data: @activity.as_json(:include => :activity), message: "Activity created successfully" } }
      else
        format.json { render json: { success: false, message: @activity.errors.full_messages.first } }
      end
    end
  end

  private

  def activity_params
    params.require(:api_contact_activity).permit(:title, :body, :activity_id, :user_id, :contact_id, :date)
  end

  def set_activity
    @contact_activity = ContactActivity.find(params[:id])
  end
end
