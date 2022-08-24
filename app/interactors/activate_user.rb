class ActivateUser < Patterns::Service
  def initialize(actor, invitation)
    @actor = actor
    @invitation = invitation
  end

  def call
    begin
      activate
      add_event
    rescue
      invitation
    end
    invitation
  end

  private

  def activate
    user = invitation.user
    user.update(permission: "true")
  end

  def add_event
    actor.events.create(user: actor, action: "activated", action_for_context: "activated user", trackable: invitation)
  end

  attr_reader :actor, :invitation
end
