class Account::InvitationsController < Account::BaseController
  def index
    authorize :account
    @invitations = Invitation.all
    @invitation = Invitation.new
  end

  def create
    authorize :account
    @invite = AddInvitation.call(invitation_params, current_user).result
    respond_to do |format|
      if @invite.errors.empty?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:invitations, partial: "account/invitations/invitation", locals: { invitation: @invite }) +
                               turbo_stream.replace(Invitation.new, partial: "account/invitations/form", locals: { invitation: Invitation.new, message: "Thank you, invitation sent." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Invitation.new, partial: "account/invitations/form", locals: { user: current_user }) }
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:first_name, :last_name, :email)
  end
end
