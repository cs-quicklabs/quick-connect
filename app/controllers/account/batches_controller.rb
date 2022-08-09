class Account::BatchesController < Account::BaseController
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    authorize :account

    @batches = Batch.all.order(:name)
    @batch = Batch.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:batches, partial: "account/batches/batch", locals: { batch: @batch }) +
                               turbo_stream.replace(Batch.new, partial: "account/batches/form", locals: { batch: Batch.new, message: "Group was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Batch.new, partial: "account/batches/form", locals: { batch: @batch }) }
      end
    end
  end

  def update
    authorize :account

    respond_to do |format|
      if @batch.update(batch_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@batch, partial: "account/batches/batch", locals: { batch: @batch, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@batch, template: "account/batches/edit", locals: { batch: @batch, messages: @batch.errors.full_messages }) }
      end
    end
  end

  def contacts
    authorize :account
    @batch = Batch.find(params[:batch_id])
  end

  def destroy
    authorize :account

    @batch.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@batch) }
    end
  end

  private

  def set_batch
    @batch ||= Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:name)
  end
end
