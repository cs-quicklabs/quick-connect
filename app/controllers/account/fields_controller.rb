class Account::FieldsController < Account::BaseController
  before_action :set_field, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @fields = Field.for_current_account.order(:name).order(created_at: :desc)
    @field = Field.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:fields, partial: "account/fields/field", locals: { field: @field }) +
                               turbo_stream.replace(Field.new, partial: "account/fields/form", locals: { field: Field.new, message: "Field was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Field.new, partial: "account/fields/form", locals: { field: @field }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @field.update(field_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@field, partial: "account/fields/field", locals: { field: @field, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@field, template: "account/fields/edit", locals: { field: @field, messages: @field.errors }) }
      end
    end
  end

  def destroy
    authorize :account

    @field.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@field) }
    end
  end

  private

  def set_field
    @field ||= Field.find(params[:id])
  end

  def field_params
    params.require(:field).permit(:account_id, :icon, :name, :protocol)
  end
end
