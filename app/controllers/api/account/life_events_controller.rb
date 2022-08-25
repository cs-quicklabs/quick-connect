class Api::Account::LifeEventsController < Api::Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize [:api, :account]
    @life_events = LifeEvent.includes(:group).order(:name)
    render json: { success: true, data: @life_events, message: "Life Events were  succesfully retreived" }
  end

  def new
    authorize [:api, :account]
    render json: { success: true, data: Group.all.where(category: "event").order(:name), message: "Groups wehre succesfully fetched" }
  end

  def edit
    authorize [:api, :account]
    render json: { success: true, data: @life_event, message: "" }
  end

  def create
    authorize [:api, :account]

    @life_event = LifeEvent.new(life_event_params)
    respond_to do |format|
      if @life_event.save
        format.json { render json: { success: true, data: @life_event, message: "Life Event was successfully created." } }
      else
        format.json { render json: { success: false, message: @life_event.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize [:api, :account]
    respond_to do |format|
      if @life_event.update(life_event_params)
        format.json { render json: { success: true, data: @life_event, message: "Life Event was successfully updated." } }
      else
        format.json { render json: { success: false, message: @life_event.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize [:api, :account]

    @life_event.destroy
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Life Event was successfully deleted." } }
    end
  end

  private

  def set_relation
    @life_event ||= LifeEvent.find(params[:id])
  end

  def life_event_params
    params.require(:api_life_event).permit(:name, :group_id)
  end
end
