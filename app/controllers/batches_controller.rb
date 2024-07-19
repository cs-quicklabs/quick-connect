class BatchesController < BaseController
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    authorize :batch
    @pagy, @batches = pagy_nil_safe(params, Batch.all.order(:name), items: 100)

    if params[:batch_id].present?
      @batch = Batch.find(params[:batch_id])
      @contacts = @batch.contacts.includes(:batches_contacts).where("contacts.archived=?", false).order("batches_contacts.created_at DESC").uniq || []
    end

    if params[:batch_id].present? && params[:contact_id].present?
      @contact = Contact.find(params[:contact_id])
    end

    render_partial("batches/batch", collection: @batches, cached: true) if stale?(@batches)
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
        Event.create(user: current_user, action: "group", action_for_context: "created a group named", trackable: @batch)
        format.turbo_stream { redirect_to batches_path(batch_id: @batch.id), notice: "Group was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Batch.new, partial: "batches/form", locals: { batch: @batch }) }
      end
    end
  end

  def update
    authorize @batch
    respond_to do |format|
      if @batch.update(batch_params)
        Event.where(trackable: @batch).touch_all
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
    @contact = Contact.find(params[:id])
    AddContactToGroup.call(@batch, current_user, @contact).result
    redirect_to batches_path(batch_id: @batch.id, contact_id: @contact.id), notice: "Contact was successfully added."
  end

  def remove
    authorize :batch
    @contact = Contact.find(params[:id])
    @batch = Batch.find(params[:batch_id])

    RemoveContactFromGroup.call(@batch, current_user, @contact).result
    redirect_to batches_path(batch_id: @batch.id), notice: "Contact was successfully removed."
  end

  def destroy
    authorize :batch
    DestroyGroup.call(current_user, @batch).result
    redirect_to batches_path, notice: "Group was successfully destroyed."
  end

  private

  def set_batch
    @batch ||= Batch.find(params[:id])
  end

  def batch_params
    params.require(:batch).permit(:name)
  end
end
