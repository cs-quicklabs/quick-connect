class AddContactActivity < Patterns::Service
  def initialize(params, actor, contact)
    @contact_activity = ContactActivity.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_activity
      add_event
    rescue
      contact_activity
    end
    contact_activity
  end

  private

  def add_activity
    contact_activity.user_id = actor.id
    contact_activity.contact_id = contact.id
    contact_activity.save!
  end

  def add_event
    contact.events.create(user: actor, action: "contact_activity", action_for_context: "added a activity for", trackable: contact_activity, action_context: "added activity")
  end

  attr_reader :contact_activity, :actor, :contact
end
