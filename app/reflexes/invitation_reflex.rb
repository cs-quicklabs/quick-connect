class InvitationReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def deactivate
    invitation = Invitation.find(element.dataset[:id])
    user = invitation.user
    user.update(permission: "false")
    current_user.events.create(user: current_user, action: "deactivated", action_for_context: "deactivated user", eventable: invitation)
    morph "#invitation_#{invitation.id}", render(partial: "account/invitations/invitation", locals: { invitation: invitation })
  end

  def activate
    invitation = Invitation.find(element.dataset[:id])
    user = invitation.user
    user.update(permission: "true")
    user.invite!
    current_user.events.create(user: current_user, action: "activated", action_for_context: "activated user", eventable: invitation)
    morph "#invitation_#{invitation.id}", render(partial: "account/invitations/invitation", locals: { invitation: invitation })
  end
end
