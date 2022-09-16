class Api::Contact::BatchesController < Api::Contact::BaseController
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
    authorize [:api, @contact, Batch]
    respond_to do |format|
      @batch = Batch.find(params[:id])
      @batch = RemoveContactFromGroup.call(@batch, @api_user, @contact).result
      format.json { render json: { success: true, data: {}, message: "Contact deleted successfully from batch" } }
    end
  end

  def create
    authorize [:api, @contact, Batch]
    respond_to do |format|
      if batch_params[:batch_id]
        @batch = Batch.find(batch_params[:batch_id])
        @batch = AddContactToGroup.call(@batch, @api_user, @contact).result
        format.json { render json: { batch: @batch, success: true, data: @contact, message: "Contact added successfully in batch" } }
      else
        format.json {
          render json: { success: false, message: "Please select group" }
        }
      end
    end
  end

  private

  def batch_params
    params.require(:api_batch).permit(:batch_id)
  end
end
