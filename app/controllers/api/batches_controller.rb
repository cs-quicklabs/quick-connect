class Api::BatchesController < Api::BaseController
  before_action :set_batch, only: %i[ show edit update destroy ]

  def index
    authorize [:api, :batch]

    @pagy, @batches = pagy_nil_safe(params, Batch.all.order(:name), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @batches, message: "Groups retrieved successfully" }
  end

  def edit
    authorize [:api, @batch]
    render json: { success: true, data: @batch, message: "Group retrieved successfully" }
  end

  def create
    authorize [:api, :batch]

    @batch = Batch.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.json {
          render json: { success: true, data: @batch, message: "Group was successfully created." }
        }
      else
        format.json { render json: { success: false, message: @batch.errors.full_messages.first } }
      end
    end
  end

  def update
    authorize [:api, @batch]

    respond_to do |format|
      if @batch.update(batch_params)
        format.json { render json: { success: true, data: @batch, message: "Group was successfully updated." } }
      else
        format.json { render json: { success: false, message: @batch.errors.full_messages.first } }
      end
    end
  end

  def contacts
    authorize [:api, :batch]
    @batch = Batch.find(params[:batch_id])
    @pagy, @contacts = pagy_array_safe(params, @batch.contacts.uniq, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "Group members retrieved successfully" }
  end

  def add
    authorize [:api, :batch]
    @batch = Batch.find(params[:batch_id])
    respond_to do |format|
      if @batch
        @contact = Contact.find(params[:search_id])
        @batch = AddContactToGroup.call(@batch, @api_user, @contact).result
        format.json {
          render json: { success: true, batch: @batch, data: @contact, message: "Contact was successfully added to group." }
        }
      else
        format.json {
          render json: { success: false, batch: @batch, message: "Group not found" }
        }
      end
    end
  end

  def remove
    authorize [:api, :batch]
    @batch = Batch.find(params[:batch_id])
    respond_to do |format|
      if @batch
        @contact = Contact.find(params[:contact_id])
        @batch.contacts.destroy @contact
        Event.where(trackable: @batch).touch_all
        @contact.events.create(user: @api_user, action: "deleted", action_for_context: "removed from group ", action_context: "Removed", trackable: @batch)
        format.json {
          render json: { success: true, batch: @batch, message: "Contact was successfully removed from group." }
        }
      else
        format.json {
          render json: { success: false, batch: @batch, message: "Group not found" }
        }
      end
    end
  end

  def destroy
    authorize :batch
    @batch.destroy
    respond_to do |format|
      format.json { render json: { success: true, message: "Group has been deleted." } }
    end
  end

  private

  def set_batch
    @batch ||= Batch.find(params[:id])
  end

  def batch_params
    params.require(:api_batch).permit(:name)
  end
end
