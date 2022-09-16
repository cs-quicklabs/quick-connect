class RemoveContactFromGroup < Patterns::Service
  def initialize(batch, actor, contact)
    @batch = batch
    @actor = actor
    @contact = contact
  end

  def call
    begin
      remove_batch
      add_event
    rescue
      batch
    end
    batch
  end

  private

  def remove_batch
    @batch.contacts.destroy @contact
  end

  def add_event
    Event.create(user: actor, action: "removed", action_for_context: "removed", action_context: "removed from group", trackable: batch, eventable: contact)
  end

  attr_reader :batch, :actor, :contact
end
