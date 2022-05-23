class Api::ContactsController < Api::BaseController
  include Pagy::Backend
  before_action :set_contact, only: %i[ edit update destroy profile archive_contact unarchive_contact ]
  respond_to :json

  def index
    authorize :contact
    @pagy, @contacts = pagy_nil_safe(params, @user.contacts.for_current_account.active.order(:first_name), items: LIMIT)
    respond_to do |format|
      format.json { render json: { success: true, data: @contacts, message: "Contacts were successfully retrieved." } }
    end
  end

  def new
    authorize :contact

    @contact = Contact.new
  end

  def edit
    authorize @contact
  end

  def update
    authorize @contact

    respond_to do |format|
      if @contact.update(contact_params)
        format.json { render json: { success: true, data: @contact, message: "Contact was successfully updated." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, title: "Edit Contact", subtitle: "Please update details of existing contact", message: "" } } }
      end
    end
  end

  def create
    authorize :contact
    @contact = CreateContact.call(contact_params, @user).result
    respond_to do |format|
      if @contact.errors.empty?
        format.json { render json: { success: true, data: @contact, message: "Contact was successfully created." } }
      else
        format.json { render json: { success: false, data: { contact: @contact, title: "Add Contact", subtitle: "Please add contact", message: "" } } }
      end
    end
  end

  def profile
    authorize @contact
  end

  def destroy
    authorize :contact
    respond_to do |format|
      if DestroyContact.call(@contact).result
        format.turbo_stream { redirect_to deactivated_contact_path, status: 303, notice: "contact has been deleted." }
      else
        format.turbo_stream { redirect_to deactivated_contact_path, status: 303, alert: "Failed to delete contact." }
      end
    end
  end

  def archived
    authorize :contact, :index?

    @pagy, @contacts = pagy_nil_safe(params, Contact.archived.order(archived_on: :desc), items: LIMIT)
    render_partial("contacts/archived_contact", collection: @contacts, cached: true) if stale?(@contacts)
  end

  def archive_contact
    authorize @contact, :update?

    ArchiveContact.call(@contact, current_user)
    redirect_to archived_contacts_path, notice: "Contact has been archived."
  end

  def unarchive_contact
    authorize @contact, :unarchive_contact?

    UnarchiveContact.call(@contact, current_user)
    redirect_to contact_about_index_path(@contact), notice: "Contact has been restored."
  end

  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :birthday, :address, :about)
  end
end
