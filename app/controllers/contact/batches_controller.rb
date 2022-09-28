class Contact::BatchesController < Contact::BaseController
  before_action :set_batch, only: %i[destroy]

  def index
    authorize [@contact, Batch]
    @pagy, @batches_contacts = pagy_nil_safe(params, BatchesContact.includes(:batch).where(contact_id: @contact.id), items: LIMIT)
    @groups = Batch.all.order(:name) - @contact.batches
    render_partial("contact/batches/batch", collection: @batches_contacts) if stale?(@batches_contacts + [@contact])
  end

  def destroy
    authorize [@contact, @batch]
    @batch = RemoveContactFromGroup.call(@batch, current_user, @contact).result
    @groups ||= Batch.all - @contact.batches
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove(@batch) +
                             turbo_stream.replace(:form, partial: "contact/batches/form", locals: { groups: @groups, contact: @contact })
      }
    end
  end

  def create
    authorize [@contact, Batch]
    @groups ||= Batch.all - @contact.batches
    respond_to do |format|
      if !params[:batch_id].blank?
        @batch = Batch.find(params[:batch_id])
        @batch_new = AddContactToGroup.call(@batch, current_user, @contact).result
        batches_contact = BatchesContact.joins(:batch).where(batch_id: @batch_new.id).where(contact_id: @contact.id).first
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(:form, partial: "contact/batches/form", locals: { groups: @groups, contact: @contact }) +
                               turbo_stream.prepend(:batches, partial: "contact/batches/batch", locals: { batches_contact: batches_contact, contact: @contact })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(:form, partial: "contact/batches/form", locals: { message: "Please select group", groups: @groups, contact: @contact }) }
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
