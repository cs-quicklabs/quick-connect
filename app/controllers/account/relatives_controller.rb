class Account::RelativesController < Account::BaseController
  before_action :set_relative, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @relatives = Relative.all.order(:name).order(created_at: :desc)
    @relative = Relative.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @relative = Relative.new(relative_params)
    respond_to do |format|
      if @relative.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:relatives, partial: "account/relatives/relative", locals: { relative: @relative }) +
                               turbo_stream.replace(Relative.new, partial: "account/relatives/form", locals: { relative: Relative.new, message: "Relative was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Relative.new, partial: "account/relatives/form", locals: { relative: @relative }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @relative.update(relative_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, partial: "account/relatives/relative", locals: { relative: @relative, messages: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@relative, template: "account/relatives/edit", locals: { relative: @relative, messages: @relative.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @relative.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@relative) }
    end
  end

  private

  def set_relative
    @relative ||= Relative.find(params[:id])
  end

  def relative_params
    params.require(:relative).permit(:name, :account_id)
  end
end
