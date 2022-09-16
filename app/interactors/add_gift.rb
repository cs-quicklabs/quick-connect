class AddGift < Patterns::Service
  def initialize(params, actor, contact)
    @gift = Gift.new params
    @actor = actor
    @contact = contact
  end

  def call
    begin
      add_gift
      add_event
    rescue
      gift
    end
    gift
  end

  private

  def add_gift
    gift.user_id = actor.id
    gift.contact_id = contact.id
    gift.save!
  end

  def add_event
    contact.events.create(user: actor, action: "gifted", action_for_context: "added a gift for", trackable: gift, action_context: "added gift")
  end

  attr_reader :gift, :actor, :contact
end
