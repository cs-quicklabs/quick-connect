class DeactivateUser < Patterns::Service
  def initialize(actor, invitation)
    @actor = actor
    @invitation = invitation
  end

  def call
    begin
      deactivate
      add_event
    rescue
      invitation
    end
    invitation
  end

  private

  def deactivate
    user = invitation.user
    user.update(permission: "false")
  end

  def add_event
    Event.create(user: actor, action: "deactivated", action_for_context: "deactivated an user", eventable: invitation)
  end

  attr_reader :actor, :invitation
end
