class CreateContact < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor)
    @contact = Contact.new(params)
    @actor = actor
  end

  def call
    create_contact
    add_event
    add_about
    begin
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
    contact.events.create(user: actor, action: "created", action_for_context: "added new contact", trackable: contact, action_context: "Added contact")
  end

  def add_about
    About.create(user: actor, contact: contact)
  end

  attr_reader :contact, :actor
end
