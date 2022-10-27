class Account::LabelsController < Account::BaseController
  before_action :set_label, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @labels = Label.all.order(:name).order(created_at: :desc)
    @label = Label.new
    fresh_when @labels
  end

  def edit
    authorize :account
  end

  def create
    authorize :account
    @label = Label.new(label_params)
    respond_to do |format|
      if @label.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:labels, partial: "account/labels/label", locals: { label: @label }) +
                               turbo_stream.replace(Label.new, partial: "account/labels/form", locals: { label: Label.new, message: "Label was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Label.new, partial: "account/labels/form", locals: { label: @label }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @label.update(label_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@label, partial: "account/labels/label", locals: { label: @label, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@label, template: "account/labels/edit", locals: { label: @label, messages: @label.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @label.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@label) }
    end
  end

  private

  def set_label
    if @label
      return @label
    end
    @label ||= Label.find(params[:id])
  end

  def label_params
    params.require(:label).permit(:color, :name)
  end
end
