class Account::ActivitiesController < Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @activities = Activity.all.joins("INNER JOIN groups ON groups.id = activities.group_id").order("groups.name ASC").order(:name).group_by(&:group)
    @activity = Activity.new
    fresh_when Activity.all
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @activity = Activity.new(activity_params)
    respond_to do |format|
      if @activity.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:activities, partial: "account/activities/activity", locals: { activity: @activity }) +
                               turbo_stream.replace(Activity.new, partial: "account/activities/form", locals: { activity: Activity.new, message: "Activity was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Activity.new, partial: "account/activities/form", locals: { activity: @activity }) }
      end
    end
  end

  def update
    authorize :account
    respond_to do |format|
      if @activity.update(activity_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@activity, partial: "account/activities/activity", locals: { activity: @activity, messages: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@activity, template: "account/activities/edit", locals: { activity: @activity, messages: @activity.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @activity.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@activity) }
    end
  end

  private

  def set_relation
    @activity ||= Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :group_id)
  end
end
