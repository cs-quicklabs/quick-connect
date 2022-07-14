class SessionsController < Devise::SessionsController
  def destroy
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    yield if block_given?
    respond_to do |format|
      format.html { redirect_to archived_contacts_path, status: :see_other, notice: "" }
    end
  end
end
