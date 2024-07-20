class CollectionsController < BaseController
  def index
    authorize :dashboard
    @collections = Collection.all

    if params[:collection_id].present?
      @collection = Collection.find(params[:collection_id])
      @batches = @collection.batches
    end

    if params[:batch_id].present?
      @batch = Batch.find(params[:batch_id])
      @contacts = @batch.contacts
      unless params[:contact_id].present?
        @events = Event.where(eventable_id: @contacts.ids, eventable_type: "Contact").order(created_at: :desc)
      end
    end

    if params[:contact_id].present?
      @contact = Contact.find(params[:contact_id])
      @events = @contact.events.order(created_at: :desc).limit(5)
    end
  end

  def create
    authorize :collection
    @collection = Collection.new(collection_params)
    respond_to do |format|
      if @collection.save
        Event.create(user: current_user, action: "collection", action_for_context: "created a collection named", trackable: @collection)
        format.turbo_stream { redirect_to collections_path(collection_id: @collection.id), notice: "Collection was created successfully." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Collection.new, partial: "collections/form", locals: { collection: @collection }) }
      end
    end
  end

  def remove_group
    authorize :dashboard, :index?
    BatchesCollection.where(batch_id: params[:batch_id], collection_id: params[:id]).delete_all

    redirect_to collections_path(collection_id: params[:id])
  end

  private

  def collection_params
    params.require(:collection).permit(:name)
  end
end
