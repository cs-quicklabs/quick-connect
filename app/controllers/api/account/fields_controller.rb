class Api::Account::FieldsController < Api::Account::BaseController
  before_action :set_field, only: %i[ show edit update destroy ]

  def index
    authorize [:api, :account]

    @fields = Field.all.order(:name).order(created_at: :desc)
    render json: { success: true, data: @fields, message: "Fields were successfully retrieved." } if stale?(@fields)
  end

  def edit
    authorize [:api, :account]
    render json: { success: true, data: @field, message: "" }
  end

  def create
    authorize [:api, :account]

    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        format.json { render json: { success: true, data: @field, message: "Contact Field Type was successfully created." } }
      else
        format.json { render json: { success: false, message: @field.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize [:api, :account]

    respond_to do |format|
      if @field.update(field_params)
        format.json { render json: { success: true, data: @field, message: "Contact Field Type was successfully updated." } }
      else
        format.json { render json: { success: false, message: @field.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize [:api, :account]
    @field.destroy
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Contact Field Type was successfully deleted." } }
    end
  end

  private

  def set_field
    if @field
      return @field
    end
    @field ||= Field.find(params[:id])
  end

  def field_params
    params.require(:api_field).permit(:icon, :name, :protocol)
  end
end
