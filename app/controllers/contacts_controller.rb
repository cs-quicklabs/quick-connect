class ContactsController < BaseController
  include Pagy::Backend

  before_action :set_contact, only: %i[ edit update destroy profile archive_contact unarchive_contact ]

  def index
    authorize :contact
    @pagy, @contacts = pagy_nil_safe(params, Contact.all.available.order(:first_name), items: LIMIT)
    fresh_when @contacts
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
        Event.where(eventable: @contact).or(Event.where(trackable: @contact)).touch_all
        format.html { redirect_to contact_about_index_path(@contact), notice: "Contact was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact, partial: "contacts/form", locals: { contact: @contact, title: "Edit Contact", subtitle: "Please update details of existing contact" }) }
      end
    end
  end

  def create
    authorize :contact
    @contact = CreateContact.call(contact_params, @user).result
    respond_to do |format|
      if @contact.errors.empty?
        format.html { redirect_to contacts_path, notice: "Contact was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Contact.new, partial: "contacts/form", locals: { contact: @contact, title: "Add New Contact", subtitle: "Please add contact" }) }
      end
    end
  end

  def profile
    authorize @contact
  end

  def archived
    authorize :contact, :index?

    @pagy, @contacts = pagy_nil_safe(params, @current_user.contacts.archived.order(archived_on: :desc), items: LIMIT)
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

  def destroy
    authorize @contact, :destroy?

    respond_to do |format|
      if DestroyContact.call(current_user, @contact).result
        format.html { redirect_to archived_contacts_path, status: :see_other, notice: "Contact has been deleted." }
      else
        format.html { redirect_to archived_contacts_path, status: :see_other, alert: "Failed to delete contact." }
      end
    end
  end

  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :birthday, :address, :about)
  end
end
