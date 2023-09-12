class UpdateTouchBack < Patterns::Service
  def initialize(contact, actor, touch_back_after)
    @contact = contact
    @actor = actor
    @touch_back_after = touch_back_after
  end

  def call
    begin
      update_touch_back
      add_event
    rescue
      contact
    end
    contact
  end

  private

  def update_touch_back
    contact.touch_back_after = touch_back_after
    contact.followup_after_changed_on = Date.today
    contact.save!
  end

  def add_event
    contact.events.create(user: actor, action: "touched", action_for_context: "updated follow up after for", trackable: contact, action_context: "updated follow up after for this contact")
  end

  attr_reader :contact, :actor, :touch_back_after
end
