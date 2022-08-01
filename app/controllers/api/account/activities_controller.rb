class Api::Account::ActivitiesController < Api::Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize [:api, :account]
    @activities = Activity.all.includes(:group).order(:name)
    render json: { success: true, data: [@activities], message: "Activities were successfully retrieved." }
  end

  def new
    authorize [:api, :account]
    render json: { success: true, data: Group.all.where(category: "activity").order(:name), message: "Groups were succesfully fetched" }
  end

  def edit
    authorize [:api, :account]
    render json: { success: true, data: @activity, message: "" }
  end

  def create
    authorize [:api, :account]

    @activity = Activity.new(activity_params)
    respond_to do |format|
      if @activity.save
        format.json { render json: { success: true, data: @activity, message: "Activity was successfully created." } }
      else
        format.json { render json: { success: false, message: @activity.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize [:api, :account]
    respond_to do |format|
      if @activity.update(relation_params)
        format.json { render json: { success: true, data: @activity, message: "Activity was successfully updated." } }
      else
        format.json { render json: { success: false, message: @activity.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize [:api, :account]

    @activity.destroy
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Activity was successfully deleted." } }
    end
  end

  private

  def set_relation
    @activity ||= Activity.find(params[:id])
  end

  def activity_params
    params.require(:api_activity).permit(:name, :group_id)
  end
end
