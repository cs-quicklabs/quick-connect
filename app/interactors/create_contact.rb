class CreateContact < Patterns::Service
  CHARS = ("0".."9").to_a + ("A".."Z").to_a + ("a".."z").to_a

  def initialize(params, actor, groups)
    @contact = Contact.new(params)
    @actor = actor
    @groups = groups
  end

  def call
    begin
      create_contact
      add_event
      add_about
      add_groups
    rescue
      contact
    end
    contact
  end

  private

  def create_contact
    contact.user = actor
    contact.account = actor.account
    contact.touched_at = DateTime.now.utc
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "created", action_for_context: "added new contact", action_context: "added this contact")
  end

  def add_about
    About.create(user: actor, contact: contact)
  end

  def add_groups
    if !groups.nil?
      @batches = Batch.where("id IN (?)", groups)
      contact.batches << @batches
    end
  end

  attr_reader :contact, :actor, :groups
end
