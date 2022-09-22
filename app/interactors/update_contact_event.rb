class UpdateContactEvent < Patterns::Service
  def initialize(contact_event, actor, params, reminder, contact)
    @contact_event = contact_event
    @actor = actor
    @params = params
    @reminder = reminder
    @contact = contact
  end

  def call
    update_contact_event
    update_event
    add_reminder
    begin
    rescue
      contact_event
    end
    contact_event
  end

  private

  def update_contact_event
    contact_event.update(params)
  end

  def add_reminder
    if reminder == "true"
      @contact_reminder = contact.reminders.create(user: actor, title: contact_event.title + " (" + contact_event.life_event.name + ")", comments: contact_event.body, reminder_date: contact_event.date, remind_after: 1, status: "year", reminder_type: "multiple")
      contact.events.create(user: actor, action: "reminder", action_for_context: "added a reminder for", trackable: @contact_reminder, action_context: "added reminder")
    end
  end

  def update_event
    Event.where(trackable: @contact_event).touch_all
  end

  attr_reader :contact_event, :actor, :params, :reminder, :contact
end
