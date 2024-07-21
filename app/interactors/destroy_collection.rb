class DestroyCollection < Patterns::Service
  def initialize(actor, collection)
    @collection = collection
    @actor = actor
  end

  def call
    begin
      destroy_collection
      update_event
    rescue
      collection
    end

    collection
  end

  private

  def destroy_collection
    BatchesCollection.where(collection_id: @collection.id).delete_all
    collection.destroy
  end

  def update_event
    Event.create(user: actor, action: "deleted_collection", action_for_context: "deleted a collection")
  end

  attr_reader :collection, :actor
end
