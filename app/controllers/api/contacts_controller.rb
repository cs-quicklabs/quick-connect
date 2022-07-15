class Api::ContactsController < Api::BaseController
  include Pagy::Backend
  before_action :set_contact, only: %i[ edit update destroy show archive_contact unarchive_contact ]
  respond_to :json

  def index
    authorize [:api, :contact]
    @pagy, @contacts = pagy_nil_safe(params, Contact.all.available.order(:first_name), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "Contacts were successfully retrieved." }
  end

  def edit
    authorize [:api, @contact]
    render json: { success: true, data: @contact, message: "Edit Contact" }
  end

  def update
    authorize [:api, @contact]
    if @contact.update(contact_params)
      Event.where(eventable: @contact).or(Event.where(trackable: @contact)).touch_all
      render json: { success: true, data: @contact, message: "Contact was successfully updated." }
    else
      render json: { success: false, message: @contact.errors.full_messages.first }
    end
  end

  def create
    authorize [:api, :contact]
    @contact = CreateContact.call(contact_params, @api_user).result
    if @contact.errors.empty?
      render json: { success: true, data: @contact, message: "Contact was successfully created." }
    else
      render json: { success: false, message: @contact.errors.full_messages.first }
    end
  end

  def show
    authorize [:api, @contact]
    render json: { success: true, data: @contact, relaives: Relative.includes(:contact).where("first_contact_id=? OR contact_id=?", @contact.id, @contact.id).as_json(:include => [:contact, :first_contact, :relation]), message: "Contact was successfully retrieved." }
  end

  def archived
    authorize [:api, :contact]
    @pagy, @contacts = pagy_nil_safe(params, @api_user.contacts.archived.order(archived_on: :desc), items: LIMIT)

    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @contacts, message: "Archived contacts were successfully retrieved." }
  end

  def archive_contact
    authorize [:api, @contact]
    ArchiveContact.call(@contact, @api_user)
    render json: { success: true, data: @contacts, message: "Contact has been archived." }
  end

  def unarchive_contact
    authorize [:api, @contact]

    UnarchiveContact.call(@contact, @api_user)
    render json: { success: true, data: @contact, message: "Contact has been restored." }
  end

  def destroy
    authorize [:api, @contact]
    if DestroyContact.call(@api_user, @contact).result
      render json: { success: true, message: "Contact has been deleted." }
    else
      render json: { success: true, message: "Failed to delete contact." }
    end
  end

  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def contact_params
    params.require(:api_contact).permit(:first_name, :last_name, :email, :phone)
  end
end
