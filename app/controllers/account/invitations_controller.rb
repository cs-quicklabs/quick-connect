class Account::InvitationsController < Account::BaseController
  before_action :set_invitation, only: %i[activate deactivate]

  def index
    authorize :account
    @invitations = Invitation.all
    @invitation = Invitation.new
  end

  def create
    authorize :account
    @invitation = AddInvitation.call(invitation_params, current_user).result
    respond_to do |format|
      if @invitation.errors.empty?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:invitations, partial: "account/invitations/invitation", locals: { invitation: @invitation }) +
                               turbo_stream.replace(Invitation.new, partial: "account/invitations/form", locals: { invitation: Invitation.new, message: "Thank you, invitation sent." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Invitation.new, partial: "account/invitations/form", locals: { invitation: @invitation }) }
      end
    end
  end

  def deactivate
    authorize :account
    if DeactivateUser.call(current_user, @invitation)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.remove(@invitation) +
                               turbo_stream.prepend(:invitations, partial: "account/invitations/invitation", locals: { invitation: @invitation })
        }
      end
    end
  end

  def activate
    authorize :account
    if ActivateUser.call(current_user, @invitation)
      respond_to do |format|
        render turbo_stream: turbo_stream.remove(@invitation) +
                             turbo_stream.prepend(:invitations, partial: "account/invitations/invitation", locals: { invitation: @invitation })
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:first_name, :last_name, :email)
  end

  def set_invitation
    @invitation = Invitation.find(params[:invitation_id])
  end
end
