class CreateContact < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor)
    @contact = Contact.new(params)
    @actor = actor
  end

  def call
    begin
      create_contact
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def create_contact
    contact.user = actor
    contact.account = actor.account
    contact.save!
  end

  def add_event
    Event.create(user: actor, action: "created", action_for_context: "added new contact", trackable: contact, action_context: "contact added")
  end

  attr_reader :contact, :actor
end
