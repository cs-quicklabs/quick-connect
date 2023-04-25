class TouchedContact < Patterns::Service
  def initialize(contact, actor)
    @contact = contact
    @actor = actor
  end

  def call
    begin
      touched
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def touched
    contact.touched_at = Date.today
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "touched", action_for_context: "touched contact", trackable: contact, action_context: "touched this contact")
  end

  attr_reader :contact, :actor
end
