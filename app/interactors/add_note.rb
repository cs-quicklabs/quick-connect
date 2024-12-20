class AddNote < Patterns::Service
  def initialize(params, actor, contact)
    @note = Note.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_note
      add_event
    rescue
      note
    end

    note
  end

  private

  def add_note
    note.user_id = actor.id
    note.contact_id = contact.id
    note.save!
  end

  def add_event
    contact.events.create(user: actor, action: "noted", action_for_context: "added a note for", trackable: note, action_context: "added a note")
  end

  attr_reader :note, :actor, :contact
end
