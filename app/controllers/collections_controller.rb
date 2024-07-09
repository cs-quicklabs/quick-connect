class CollectionsController < BaseController
  def index
    authorize :dashboard
    @collections = Collection.all

    if params[:collection_id].present?
      @batches = Collection.find(params[:collection_id]).batches
    end

    if params[:batch_id].present?
      @contacts = Batch.find(params[:batch_id]).contacts
    end

    if params[:contact_id].present?
      @contact = Contact.find(params[:contact_id])
    end
  end
end
