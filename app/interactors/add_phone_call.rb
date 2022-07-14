class AddPhoneCall < Patterns::Service
  def initialize(params, actor, contact)
    @phone_call = PhoneCall.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_phonecall
      add_event
    rescue
      phone_call
    end
    phone_call
  end

  private

  def add_phonecall
    phone_call.user_id = actor.id
    phone_call.contact_id = contact.id
    phone_call.save!
  end

  def add_event
    contact.events.create(user: actor, action: "called", action_for_context: "added a phone call for", trackable: phone_call, action_context: "Added phone call")
  end

  attr_reader :phone_call, :actor, :contact
end
