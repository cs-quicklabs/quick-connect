class Account::InvitationsController < Account::BaseController
  before_action :set_invitation, only: %i[activate deactivate]

  def index
    authorize :account, :invitation?
    @invitations = Invitation.all.order(created_at: :desc)
    @invitation = Invitation.new
    fresh_when @invitations
  end

  def create
    authorize :account, :invitation?
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
    authorize :account, :invitation?
    if DeactivateUser.call(current_user, @invitation)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@invitation, partial: "account/invitations/invitation", locals: { invitation: @invitation })
        }
      end
    end
  end

  def activate
    authorize :account, :invitation?
    if ActivateUser.call(current_user, @invitation)
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@invitation, partial: "account/invitations/invitation", locals: { invitation: @invitation })
        }
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:first_name, :last_name, :email)
  end

  def set_invitation
    if @invitation
      return @document
    end
    @invitation = Invitation.find(params[:invitation_id])
  end
end
