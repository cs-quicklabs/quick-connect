class DestroyContact < Patterns::Service
  def initialize(contact)
    @contact = contact
  end

  def call
    begin
      delete_events
      delete_notes
      delete_tasks
      delete_relatives
      delete_conversations
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
    contact.relatives.delete_all
  end

  def delete_conversations
    contact.conversations.delete_all
  end

  def delete_events
    contact.events.delete_all
  end

  attr_reader :contact
end
