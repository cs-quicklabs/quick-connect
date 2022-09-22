class AddContactEvent < Patterns::Service
  def initialize(params, actor, contact, reminder)
    @contact_event = ContactEvent.new params
    @actor = actor
    @contact = contact
    @reminder = reminder
  end

  def call
    begin
      add_contact_event
      add_event
      add_reminder
    rescue
      contact_event
    end
    contact_event
  end

  private

  def add_contact_event
    contact_event.user_id = actor.id
    contact_event.contact_id = contact.id
    contact_event.save!
  end

  def add_reminder
    if reminder == "true"
      @contact_reminder = contact.reminders.create(user: actor, title: contact_event.title + " (" + contact_event.life_event.name + ")", comments: contact_event.body, reminder_date: contact_event.date, remind_after: 1, status: "year", reminder_type: "multiple")
      contact.events.create(user: actor, action: "reminder", action_for_context: "added a reminder for", trackable: @contact_reminder, action_context: "added reminder")
    end
  end

  def add_event
    contact.events.create(user: actor, action: "contact_event", action_for_context: "added a event for", trackable: contact_event, action_context: "added event")
  end

  attr_reader :contact_event, :actor, :contact, :reminder
end
