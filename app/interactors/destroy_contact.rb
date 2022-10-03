class DestroyContact < Patterns::Service
  def initialize(actor, contact)
    @actor = actor
    @contact = contact
  end

  def call
    begin
      delete_events
      add_event
      delete_notes
      delete_tasks
      delete_relatives
      delete_conversations
      delete_debts
      delete_gifts
      delete_contact_activities
      delete_contact_about
      delete_contact_events
      delete_reminders
      delete_contact_batches
      contact.destroy
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
    Relative.where("first_contact_id=? OR contact_id=?", @contact.id, @contact.id).delete_all
  end

  def delete_conversations
    contact.conversations.delete_all
  end

  def delete_events
    Event.where(trackable: contact).delete_all
    Event.where(eventable: contact).delete_all
  end

  def delete_debts
    contact.debts.delete_all
  end

  def delete_gifts
    contact.gifts.delete_all
  end

  def delete_contact_activities
    contact.contact_activities.delete_all
  end

  def delete_contact_events
    contact.contact_events.delete_all
  end

  def delete_contact_about
    if !contact.abouts.nil?
      contact.abouts.delete
    end
  end

  def delete_contact_batches
    BatchesContact.where(contact_id: @contact.id).destroy_all
  end

  def delete_reminders
    contact.reminders.delete_all
  end

  def add_event
    @event = Event.create(user: actor, action: "deleted", action_for_context: "deleted a contact")
    @event.save!
  end

  attr_reader :contact, :actor
end
