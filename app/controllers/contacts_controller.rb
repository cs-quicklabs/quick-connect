class ContactsController < BaseController
  include Pagy::Backend

  before_action :set_contact, only: %i[ edit update destroy profile archive_contact unarchive_contact untrack track ]

  def index
    authorize :contact
    @pagy, @contacts = pagy_nil_safe(params, Contact.all.available.order(:first_name), items: LIMIT)
    respond_to do |format|
      format.html
      format.json {
        render json: { entries: render_to_string(partial: "contacts/contact", formats: [:html], collection: @contacts, cached: cached),
                       pagination: render_to_string(partial: "shared/paginator", formats: [:html], locals: { pagy: @pagy }) }
      }
      format.html
      format.csv { send_data Contact.all.available.order(:first_name).to_csv, filename: "contacts-#{Date.today}.csv" }
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
        Event.where(eventable: @contact).touch_all
        format.html { redirect_to contact_abouts_path(@contact), notice: "Contact was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@contact, partial: "contacts/form", locals: { contact: @contact, title: "Edit Contact", subtitle: "Please update details of existing contact" }) }
      end
    end
  end

  def import
    authorize :contact
    @import = Contact.import(file_params[:file_name], current_user)
    respond_to do |format|
      if @import.first > 1
        format.html { redirect_to contacts_path, notice: "Imported #{@import} contacts" }
      elsif @import.first == 1
        format.html { redirect_to contacts_path, notice: "Imported #{@import} contact" }
      else
        format.html { redirect_to contacts_path, :alert => "There were no contacts imported from your file" }
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
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Contact.new, partial: "contacts/form", locals: { contact: @contact, title: "Add New Contact", subtitle: "Please provide details of new contact" }) }
      end
    end
  end

  def profile
    authorize @contact
  end

  def archived
    authorize :contact, :index?

    @pagy, @contacts = pagy_nil_safe(params, Contact.all.archived.order(archived_on: :desc), items: LIMIT)
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
    redirect_to contact_abouts_path(@contact), notice: "Contact has been restored."
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

  def untracked
    authorize :contact, :index?

    @pagy, @contacts = pagy_nil_safe(params, Contact.all.untracked.order(archived_on: :desc), items: LIMIT)
    render_partial("contacts/untracked_contact", collection: @contacts, cached: true) if stale?(@contacts)
  end

  def untrack
    authorize :contact, :untrack?

    UntrackContact.call(@contact, current_user)

    render turbo_stream: turbo_stream.remove(@contact)
  end

  def track
    authorize @contact, :track?
    TrackContact.call(@contact, current_user)
    redirect_to followups_path, notice: "Contact has been tracked."
  end

  private

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def file_params
    params.require(:contact).permit(:file_name)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :relation_id, :intro)
  end
end
