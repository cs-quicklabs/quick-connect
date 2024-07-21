class CollectionsController < BaseController
  before_action :set_collection, only: %i[ show edit update destroy ]

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

  def destroy
    authorize @collection
    DestroyCollection.call(current_user, @collection).result
    redirect_to collections_path, notice: "Collection was successfully destroyed."
  end

  def edit
    authorize @collection
  end

  def update
    authorize @collection
    respond_to do |format|
      if @collection.update(collection_params)
        Event.where(trackable: @collection).touch_all
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@collection, partial: "collections/collection", locals: { collection: @collection, message: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@collection, template: "collections/edit", locals: { collection: @collection, messages: @collection.errors.full_messages }) }
      end
    end
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:name)
  end
end
