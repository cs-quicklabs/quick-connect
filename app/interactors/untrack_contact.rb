class UntrackContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    begin
      untrack
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def untrack
    contact.track = false
    contact.untrack_on = Date.today
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "untrack", action_for_context: "untracked contact", trackable: contact, action_context: "Untracked")
  end

  attr_reader :contact, :actor
end
