class AddContactToGroup < Patterns::Service
  def initialize(batch, actor, contact)
    @batch = batch
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_batch
      add_event
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
    contact.events.create(user: actor, action: "batch", action_for_context: "added " + @contact.decorate.display_name + " to " + @batch.name, trackable: batch, action_context: "Added to group " + @batch.name)
  end

  attr_reader :batch, :actor, :contact
end
