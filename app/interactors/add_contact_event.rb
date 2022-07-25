class AddContactEvent < Patterns::Service
  def initialize(params, actor, contact)
    @contact_event = ContactEvent.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_contact_event
      add_event
    rescue
      contact_event
    end
    contact_event
  end

  private

  def add_contact_event
    contact_event.user_id = actor.id
    contact_event.contact_id = contact.id
    contact_event.save!
  end

  def add_event
    contact.events.create(user: actor, action: "contact_event", action_for_context: "added a event for", trackable: contact_event, action_context: "Added event")
  end

  attr_reader :contact_event, :actor, :contact
end
