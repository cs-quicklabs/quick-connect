class DestroyNote < Patterns::Service
  def initialize(contact, actor, note)
    @note = note
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_note
      update_event
    rescue
      note
    end

    note
  end

  private

  def destroy_note
    @note.destroy
  end

  def update_event
    Event.where(trackable: @note).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a note for", action_context: "Deleted note")
  end

  attr_reader :note, :contact, :actor
end
