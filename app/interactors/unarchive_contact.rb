class UnarchiveContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    begin
      unarchive
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def unarchive
    contact.archived = false
    contact.archived_on = nil
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "unarchived", action_for_context: "unarchived contact", action_context: "unarchived this contact")
  end

  attr_reader :contact, :actor
end
