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
end
