class Api::Account::LabelsController < Api::Account::BaseController
  before_action :set_label, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @labels = Label.for_current_account.order(:name).order(created_at: :desc)
    render json: { success: true, data: @labels, message: "Labels were successfully retrieved." }
  end

  def new
    authorize :account
    @label = Label.new
    render json: { success: true, data: @label, message: "" }
  end

  def edit
    authorize :account
    render json: { success: true, data: @label, message: "" }
  end

  def create
    authorize :account

    @label = Label.new(label_params)

    respond_to do |format|
      if @label.save
        format.json { render json: { success: true, data: @label, message: "Label was successfully created." } }
      else
        format.json { render json: { success: false, data: @label, message: @label.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @label.update(label_params)
        format.json { render json: { success: true, data: @label, message: "Label was successfully updated." } }
      else
        format.json { render json: { success: false, data: @label, message: @label.errors.full_messages.first } }
      end
    end
  end

  def destroy
    authorize :account

    @label.destroy
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Label was successfully deleted." } }
    end
  end

  private

  def set_label
    @label ||= Label.find(params[:id])
  end

  def label_params
    params.require(:api_label).permit(:account_id, :color, :name)
  end
end
