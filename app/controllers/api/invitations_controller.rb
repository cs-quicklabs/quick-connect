class Api::InvitationsController < Devise::InvitationsController
  prepend_before_action :require_no_authentication, only: [:update]

  def update
    raw_invitation_token = update_resource_params[:invitation_token]
    self.resource = accept_resource
    invitation_accepted = resource.errors.empty?

    yield resource if block_given?

    if invitation_accepted
      resource.after_database_authentication
      sign_in(resource_name, resource)
      respond_with resource do |format|
        format.json {
          render json: { success: true,
                         data: { jwt: current_token, user: resource.as_json(only: [:account_id, :email]) },
                         message: "Authentication successful" }
        }
      end
    else
      render json: { success: false, message: resource.errors.full_messages.first }
    end
  end
end
