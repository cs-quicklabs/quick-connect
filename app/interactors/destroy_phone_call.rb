class DestroyPhoneCall < Patterns::Service
  def initialize(contact, actor, phone_call)
    @phone_call = phone_call
    @contact = contact
    @actor = actor
  end

  def call
    begin
      destroy_phone_call
      update_event
    rescue
      phone_call
    end
    phone_call
  end

  private

  def destroy_phone_call
    @phone_call.destroy
  end

  def update_event
    Event.where(trackable: @phone_call).touch_all
    @contact.events.create(user: actor, action: "deleted", action_for_context: "deleted a phone call for", action_context: "Deleted phone call")
  end

  attr_reader :phone_call, :contact, :actor
end
