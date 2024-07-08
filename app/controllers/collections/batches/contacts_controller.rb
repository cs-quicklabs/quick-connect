class Collections::Batches::ContactsController < ApplicationController
  def index
    @collections = Collection.all
    @batches = Collection.find(params[:id]).batches
    @contacts = Batch.find(params[:batch_id]).contacts
  end
end
