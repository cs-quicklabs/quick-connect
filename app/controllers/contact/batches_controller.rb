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

    @contact.batches.destroy @batch
    Event.where(trackable: @batch).touch_all
    @contact.events.create(user: current_user, action: "deleted", action_for_context: "removed " + @contact.decorate.display_name + " from " + @batch.name, trackable: @batch, action_context: "Removed from group " + @batch.name)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@batch) }
    end
  end

  def create
    authorize [@contact, Batch]
    respond_to do |format|
      if !params[:batch_id].blank?
        @batch = Batch.find(params[:batch_id])
        @batch_new = AddContactToGroup.call(@batch, current_user, @contact).result
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:batches, partial: "contact/batches/batch", locals: { batch: @batch, contact: @contact }) +
                               turbo_stream.replace(:form, partial: "contact/batches/form", locals: { groups: Batch.all - @contact.batches, contact: @contact })
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
