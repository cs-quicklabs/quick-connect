class InvitationReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def deactivate
    invitation = Invitation.find(element.dataset[:id])
    user = User.find_by_email(invitation.email)
    user.update(permission: "false")
    current_user.events.create(user: current_user, action: "deactivated", action_for_context: "deactivated user", trackable: invitation)
  end

  def activate
    invitation = Invitation.find(element.dataset[:id])
    user = User.find_by_email(invitation.email)
    user.update(permission: "true")
    user.invite!
    current_user.events.create(user: current_user, action: "activated", action_for_context: "activated user", trackable: invitation)
  end
end
