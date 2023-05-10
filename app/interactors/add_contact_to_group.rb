class AddContactToGroup < Patterns::Service
  def initialize(batch, actor, contact)
    @batch = batch
    @actor = actor
    @contact = contact
  end

  def call
    add_batch
    add_event
    begin
    rescue
      batch
    end
    batch
  end

  private

  def add_batch
    @batch.contacts << @contact
  end

  def add_event
    Event.create(user: actor, action: "batch", action_for_context: "added", action_context: "added this contact to group named", trackable: batch, eventable: contact)
  end

  attr_reader :batch, :actor, :contact
end
