class DestroyContact < Patterns::Service
  def initialize(actor, contact)
    @actor = actor
    @contact = contact
  end

  def call
    begin
      delete_events
      delete_notes
      delete_tasks
      delete_relatives
      delete_conversations
      delete_debts
      delete_gifts
      contact.destroy
      add_event
    rescue Exception => e
      return false
    end
    true
  end

  private

  def delete_notes
    contact.notes.delete_all
  end

  def delete_tasks
    contact.tasks.delete_all
  end

  def delete_relatives
    contact.relatives.delete_all
  end

  def delete_conversations
    contact.conversations.delete_all
  end

  def delete_events
    contact.events.delete_all
  end

  def delete_debts
    contact.debts.delete_all
  end

  def delete_gifts
    contact.gifts.delete_all
  end

  def add_event
    @event = Event.create(user: actor, action: "deleted", action_for_context: "deleted a contact")
    @event.save!
  end

  attr_reader :contact, :actor
end
