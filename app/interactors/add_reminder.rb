class AddReminder < Patterns::Service
  def initialize(params, actor, contact)
    @reminder = Reminder.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_reminder
      add_event
    rescue
      reminder
    end
    reminder
  end

  private

  def add_reminder
    reminder.user_id = actor.id
    reminder.contact_id = contact.id
    reminder.save!
  end

  def add_event
    contact.events.create(user: actor, action: "reminder", action_for_context: "added new reminder for", trackable: reminder, action_context: "added new reminder titled")
  end

  attr_reader :reminder, :actor, :contact
end
