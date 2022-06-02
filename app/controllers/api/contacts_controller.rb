class Api::ContactsController < Api::BaseController
  include Pagy::Backend
  before_action :set_contact, only: %i[ edit update destroy show archive_contact unarchive_contact ]
  respond_to :json

  def index
    authorize :contact
    @pagy, @contacts = pagy_nil_safe(params, @user.contacts.for_current_account.active.order(:first_name), items: LIMIT)
    render json: { success: true, data: @contacts, message: "Contacts were successfully retrieved." }
  end

  def new
    authorize :contact

    @contact = Contact.new
    render json: { success: true, data: @contact, message: "" }
  end

  def edit
    authorize @contact
    render json: { success: true, data: @contact, message: "" }
  end

  def update
    authorize @contact
    if @contact.update(contact_params)
      render json: { success: true, data: @contact, message: "Contact was successfully updated." }
    else
      render json: { success: false, data: @contact, message: @contact.errors }
    end
  end

  def create
    authorize :contact
    @contact = CreateContact.call(contact_params, @user).result
    if @contact.errors.empty?
      render json: { success: true, data: @contact, message: "Contact was successfully created." }
    else
      render json: { success: false, data: @contact, message: @contact.errors }
    end
  end

  def show
    authorize @contact
    render json: { success: true, data: @contact, message: "Contact was successfully retrieved." }
  end

  def destroy
    authorize :contact
    if DestroyContact.call(@contact).result
      render json: { success: true, data: {}, message: "contact has been deleted." }
    else
      render json: { success: false, data: {}, message: "Failed to delete contact." }
    end
  end

  def archived
    authorize :contact, :index?

    @pagy, @contacts = pagy_nil_safe(params, Contact.archived.order(archived_on: :desc), items: LIMIT)
    render json: { success: true, data: @contacts, message: "Archived contacts were successfully retrieved." }
  end

  def archive_contact
    authorize @contact, :update?
    @pagy, @contacts = pagy_nil_safe(params, Contact.archived.order(archived_on: :desc), items: LIMIT)
    ArchiveContact.call(@contact, current_user)
    render json: { success: true, data: @contacts, message: "Contact has been archived." }
  end

  def unarchive_contact
    authorize @contact, :unarchive_contact?

    UnarchiveContact.call(@contact, current_user)
    render json: { success: true, data: @contact, message: "Contact has been restored." }
  end

  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def contact_params
    params.require(:api_contact).permit(:first_name, :last_name, :email, :phone)
  end
end
