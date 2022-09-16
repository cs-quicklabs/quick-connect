class TrackContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    track
    add_event
    begin
    rescue
      contact
    end
    contact
  end

  private

  def track
    contact.track = true
    contact.untrack_on = nil
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "track", action_for_context: "tracked contact", trackable: contact, action_context: "Tracked")
  end

  attr_reader :contact, :actor
end
