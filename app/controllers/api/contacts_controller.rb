class Api::ContactsController < Api::BaseController
  include Pagy::Backend
  before_action :set_contact, only: %i[ edit update destroy show archive_contact unarchive_contact ]
  respond_to :json

  def index
    authorize [:api, :contact]
    @pagy, @contacts = pagy_nil_safe(params, Contact.for_current_account.active.order(:first_name), items: LIMIT)
    render json: { success: true, data: @contacts, message: "Contacts were successfully retrieved." }
  end

  def edit
    authorize [:api, @contact]
    render json: { success: true, data: @contact, message: "" }
  end

  def update
    authorize [:api, @contact]
    if @contact.update(contact_params)
      render json: { success: true, data: @contact, message: "Contact was successfully updated." }
    else
      render json: { success: false, data: @contact, message: @contact.errors.full_messages }
    end
  end

  def create
    authorize [:api, :contact]
    @contact = CreateContact.call(contact_params, @api_user).result
    if @contact.errors.empty?
      render json: { success: true, data: @contact, message: "Contact was successfully created." }
    else
      render json: { success: false, data: @contact, message: @contact.errors.full_messages }
    end
  end

  def show
    authorize [:api, @contact]
    render json: { success: true, data: @contact, message: "Contact was successfully retrieved." }
  end

  def archived
    authorize [:api, @contact]

    @pagy, @contacts = pagy_nil_safe(params, Contact.for_current_account.archived.order(archived_on: :desc), items: LIMIT)
    render json: { success: true, data: @contacts, message: "Archived contacts were successfully retrieved." }
  end

  def archive_contact
    authorize [:api, @contact]
    ArchiveContact.call(@contact, current_user)
    render json: { success: true, data: @contacts, message: "Contact has been archived." }
  end

  def unarchive_contact
    authorize [:api, @contact]

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
