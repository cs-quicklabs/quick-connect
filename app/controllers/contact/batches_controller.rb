class Contact::BatchesController < Contact::BaseController
  before_action :set_batch, only: %i[destroy]

  def index
    authorize [@contact, Batch]
    @pagy, @batches = pagy_nil_safe(params, @contact.batches, items: LIMIT)
    @groups = Batch.all.order(:name) - @contact.batches
    render_partial("contact/batches/batch", collection: @batches) if stale?(@batches)
  end

  def destroy
    authorize [@contact, @batch]
    @batch = RemoveContactFromGroup.call(@batch, current_user, @contact).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@batch) }
    end
  end

  def create
    authorize [@contact, Batch]
    respond_to do |format|
      if !params[:batch_id].blank?
        @batch = Batch.find(params[:batch_id])
        @groups ||= Batch.all - @contact.batches
        @batch_new = AddContactToGroup.call(@batch, current_user, @contact).result
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(:form, partial: "contact/batches/form", locals: { groups: @groups, contact: @contact }) +
                               turbo_stream.prepend(:batches, partial: "contact/batches/batch", locals: { batch: @batch, contact: @contact })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:form, partial: "contact/batches/form", locals: { message: "Please select group", groups: Batch.all - @contact.batches, contact: @contact }) }
      end
    end
  end

  private

  def batch_params
    params.require(:batch).permit(:batch_id)
  end

  def set_batch
    @batch = Batch.find(params[:id])
  end
end
