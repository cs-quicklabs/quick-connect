class Contact::DebtsController < Contact::BaseController
  before_action :set_debt, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Debt]
    @debt = Debt.new
    @pagy, @debts = pagy_nil_safe(params, @contact.debts.order(created_at: :desc), items: LIMIT)
    render_partial("contact/debts/debt", collection: @debts) if stale?(@debts + [@contact])
  end

  def destroy
    authorize [@contact, @debt]

    @debt = DestroyContactDetail.call(@contact, current_user, @debt).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@debt) }
    end
  end

  def edit
    authorize [@contact, @debt]
  end

  def update
    authorize [@contact, @debt]

    respond_to do |format|
      if @debt.update(debt_params)
        Event.where(trackable: @debts).touch_all
        format.html { redirect_to contact_debts_path(@contact), notice: "Debt was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@debt, template: "contact/debts/edit", locals: { debt: @debt }) }
      end
    end
  end

  def create
    authorize [@contact, Debt]

    @debt = AddDebt.call(debt_params, current_user, @contact).result
    respond_to do |format|
      if @debt.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:debts, partial: "contact/debts/debt", locals: { debt: @debt }) +
                               turbo_stream.replace(Debt.new, partial: "contact/debts/form", locals: { debt: Debt.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Debt.new, partial: "contact/debts/form", locals: { debt: @debt }) }
      end
    end
  end

  private

  def set_debt
    if @debt
      return @debt
    end
    @debt = Debt.find(params["id"])
  end

  def debt_params
    params.require(:debt).permit(:title, :amount, :due_date, :owed_by)
  end
end
