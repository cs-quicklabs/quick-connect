class ActivateUser < Patterns::Service
  def initialize(actor, invitation)
    @actor = actor
    @invitation = invitation
    @user = invitation.user
  end

  def call
    begin
      activate
      invite_user
      add_event
    rescue
      invitation
    end
    invitation
  end

  private

  def activate
    user.update(permission: "true")
  end

  def invite_user
    user.invite!
  end

  def add_event
    actor.events.create(user: actor, action: "activated", action_for_context: "activated user", trackable: invitation)
  end

  attr_reader :actor, :invitation, :user
end
