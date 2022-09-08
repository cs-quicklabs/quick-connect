class Api::Contact::BatchesController < Api::Contact::BaseController
  before_action :set_batch, only: %i[destroy]

  def index
    authorize [:api, @contact, Batch]
    @pagy, @batches = pagy_nil_safe(params, @contact.batches, items: LIMIT)

    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @batches, message: "Contact batches" }
  end

  def new
    authorize [:api, @contact, Batch]
    @groups = Batch.all.order(:name) - @contact.batches
    render json: { success: true, data: @groups, message: "Add contact to group" }
  end

  def destroy
    authorize [:api, @contact, @batch]

    @contact.batches.destroy @batch
    Event.create(user: current_user, action: "deleted", action_for_context: "removed " + @contact.decorate.display_name + " from", action_context: "Removed from ", eventable: @batch)
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Contact deleted successfully from batch" } }
    end
  end

  def create
    authorize [:api, @contact, Batch]
    @batch = Batch.find(batch_params[:batch_id])
    @batch = AddContactToGroup.call(@batch, @api_user, @contact).result
    respond_to do |format|
      format.json { render json: { batch: @batch, success: true, data: @contact, message: "Contact added successfully in batch" } }
    end
  end

  private

  def batch_params
    params.require(:api_batch).permit(:batch_id)
  end

  def set_batch
    @batch = Batch.find(params[:id])
  end
end
