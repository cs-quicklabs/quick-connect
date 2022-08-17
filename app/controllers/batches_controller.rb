class BatchesController < BaseController
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    authorize :batch

    @pagy, @batches = pagy_nil_safe(params, Batch.all.order(:name), items: LIMIT)
    @batch = Batch.new
    if (params[:batch_id])
      @batch_show = Batch.find(params[:batch_id])
    end
    render_partial("batches/batch", collection: @batches) if stale?(@batches)
  end

  def edit
    authorize @batch
  end

  def show
    authorize @batch
    @pagy, @batches = pagy_nil_safe(params, Batch.all.order(:name), items: LIMIT)
    @batch = Batch.new
  end

  def create
    authorize :batch

    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:batches, partial: "batches/batch", locals: { batch: @batch }) +
                               turbo_stream.replace(Batch.new, partial: "batches/form", locals: { batch: Batch.new, message: "Group was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Batch.new, partial: "batches/form", locals: { batch: @batch }) }
      end
    end
  end

  def update
    authorize @batch

    respond_to do |format|
      if @batch.update(batch_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@batch, partial: "batches/batch", locals: { batch: @batch, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@batch, template: "batches/edit", locals: { batch: @batch, messages: @batch.errors.full_messages }) }
      end
    end
  end

  def contacts
    authorize :batch
    @batch = Batch.find(params[:batch_id])
  end

  def add
    authorize :batch
    @batch = Batch.find(params[:batch_id])
    @contact = Contact.find(params[:search_id])
    @batch = AddContactToGroup.call(@batch, current_user, @contact).result
    @batch.contacts << @contact
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.prepend(:batch_contacts, partial: "batches/contact", locals: { contact: @contact, batch: @batch }) +
                             turbo_stream.replace(:search, partial: "batches/search", locals: { batch: @batch, message: "Contact was created successfully added." })
      }
    end
  end

  def remove
    authorize :batch
    @batch = Batch.find(params[:batch_id])
    @contact = Contact.find(params[:contact_id])

    @batch.contacts.destroy @contact
    Event.where(trackable: @batch).touch_all
    @contact.events.create(user: current_user, action: "deleted", action_for_context: "removed " + @contact.decorate.display_name + " from " + @batch.name, trackable: @batch, action_context: "Removed from group " + @batch.name)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@contact) }
    end
  end

  def destroy
    authorize :batch

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
