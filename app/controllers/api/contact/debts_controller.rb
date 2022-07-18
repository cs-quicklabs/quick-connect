class Api::Contact::DebtsController < Api::Contact::BaseController
  before_action :set_debt, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Debt]
    @debt = Debt.new
    @pagy, @debts = pagy_nil_safe(params, @contact.debts.order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @debts, message: "Contact debts" }
  end

  def destroy
    authorize [:api, @contact, @debt]

    @debt = DestroyContactDetail.call(@contact, @api_user, @debt).result
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Debt was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @contact, @debt]
    render json: { success: true, data: @debt, message: "Edit Debt" }
  end

  def show
    authorize [:api, @contact, @debt]
    render json: { success: true, data: @debt, message: "Show Debt" }
  end

  def update
    authorize [:api, @contact, @debt]

    respond_to do |format|
      if @debt.update(debt_params)
        Event.where(trackable: @debts).touch_all
        format.json { render json: { success: true, data: @debt, message: "Debt was successfully updated." } }
      else
        format.json { render json: { success: false, message: @debt.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Debt]

    @debt = AddDebt.call(debt_params, @api_user, @contact).result
    respond_to do |format|
      if @debt.persisted?
        format.json { render json: { success: true, data: @debt, message: "Debt was successfully created." } }
      else
        format.json { render json: { success: false, message: @debt.errors.full_messages.first } }
      end
    end
  end

  def status
    authorize [:api, @contact, Debt]
    @debt = Debt.find(params["debt_id"])
    @debt.update(completed: !@debt.completed)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @debt, message: "Debt was successfully updated." }
  end

  private

  def set_debt
    @debt = Debt.find(params["id"])
  end

  def debt_params
    params.require(:api_debt).permit(:title, :amount, :due_date, :owed_by)
  end
end
