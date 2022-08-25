class ArchiveContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    archive
    add_event
    begin
    rescue
      contact
    end
    contact
  end

  private

  def archive
    contact.archived = true
    contact.archived_on = Date.today
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "archived", action_for_context: "archived contact", trackable: contact, action_context: "Archived")
  end

  attr_reader :contact, :actor
end
