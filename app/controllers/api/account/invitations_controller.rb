class Api::Account::InvitationsController < Api::Account::BaseController
  before_action :set_invitation, only: %i[activate deactivate]

  def index
    authorize :account
    @invitations = Invitation.all.order(created_at: :desc)
    render json: { success: true, data: @invitations.as_json(:include => [:user, :sender]), message: "Invitations were successfully retrieved." } if stale?(@invitations)
  end

  def create
    authorize :account
    @invitation = AddInvitation.call(invitation_params, @api_user).result
    respond_to do |format|
      if @invitation.errors.empty?
        format.json {
          render json: { success: true, data: @invitation.as_json(:include => [:user, :sender]), message: "Invitation was successfully created." }
        }
      else
        format.json { render json: { success: false, message: @invitation.errors.full_messages.first } }
      end
    end
  end

  def deactivate
    authorize :account
    if DeactivateUser.call(@api_user, @invitation)
      respond_to do |format|
        format.json {
          render json: { success: true, data: @invitation.as_json(:include => [:user, :sender]), message: "Invitation was successfully deactivated." }
        }
      end
    end
  end

  def activate
    authorize :account
    if ActivateUser.call(@api_user, @invitation)
      respond_to do |format|
        format.json {
          render json: { success: true, data: @invitation.as_json(:include => [:user, :sender]), message: "Invitation was successfully activated." }
        }
      end
    end
  end

  private

  def invitation_params
    params.require(:api_invitation).permit(:first_name, :last_name, :email)
  end

  def set_invitation
    @invitation = Invitation.find(params[:invitation_id])
  end
end
