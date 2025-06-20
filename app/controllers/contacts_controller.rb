class ContactsController < BaseController
  include Pagy::Backend

  before_action :set_contact, only: %i[ edit update destroy profile archive_contact unarchive_contact untrack track touched touch_back update_touched ]

  def index
    authorize :contact
    if params[:id].present?
      @contact = Contact.find(params[:id])
      @event = @contact.events.order(created_at: :desc).first
      @call = @contact.phone_calls.order(created_at: :desc).first
    end
    @pagy, @contacts = pagy_nil_safe(params, Contact.available.includes(:links, :events).order(:first_name), items: 100)
    render_partial("contacts/contact", collection: @contacts, cached: true) if stale?(@contacts)
  end

  def new
    authorize :contact
    @contact = Contact.new
    @batches = Batch.all.order(:name)
  end

  def edit
    authorize @contact
    @contact_batches = @contact.batches
    @batches = Batch.all.order(:name)
  end

  def update
    authorize @contact
    @contact = UpdateContact.call(contact_params, @contact, params[:groups]).result
    respond_to do |format|
      if @contact.errors.empty? && params[:commit] != "Save And Add More"
        format.html { redirect_to contact_about_index_path(@contact), notice: "Contact was successfully updated." }
      elsif @contact.errors.empty? && params[:commit] == "Save And Add More"
        format.html { redirect_to new_contact_path, notice: "Contact was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update(:edit, partial: "contacts/form", locals: { contact: @contact, title: "Edit Contact", subtitle: "Please update details of existing contact", batches: Batch.all.order(:name), contact_batches: @contact.batches }) }
      end
    end
  end

  def import
    authorize :contact
    @contacts = []
    respond_to do |format|
      if params[:contact]
        @contacts = Contact.import(file_params[:filename], current_user)
        if !params[:commit]
          format.turbo_stream {
            render turbo_stream: turbo_stream.update(:imported_contacts, partial: "account/import/contact", locals: { contacts: @contacts })
          }
        else
          @import = Contact.save_all(@contacts)
          if @import > 1
            Event.create(user: current_user, action: "imported", action_for_context: "imported #{@import} contacts via csv")
            format.html { redirect_to account_import_contacts_path, notice: "Imported #{@import} contacts" }
          elsif @import == 1
            Event.create(user: current_user, action: "imported", action_for_context: "imported #{@import} contact via csv")
            format.html { redirect_to account_import_contacts_path, notice: "Imported #{@import} contact" }
          else
            format.html { redirect_to account_import_contacts_path, :alert => "There were no contacts imported from your file" }
          end
        end
      else
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(:form, partial: "account/import/form", locals: { messages: "Please upload file" })
        }
      end
    end
  end

  def create
    authorize :contact
    @contact = CreateContact.call(contact_params, @user, params[:groups]).result
    respond_to do |format|
      if @contact.errors.empty?
        path = (should_add_more_contacts? ? new_contact_path : contact_about_index_path(@contact))
        format.html { redirect_to path, notice: "Contact was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.update(:new, partial: "contacts/form", locals: { contact: @contact, title: "Add New Contact", subtitle: "Please provide details of new contact", batches: Batch.all.order(:name), contact_batches: [] }) }
      end
    end
  end

  def profile
    authorize @contact
    @partial = render_to_string(partial: "contacts/profile", locals: { contact: @contact, event: @contact.last_event, call: @contact.phone_calls.order(created_at: :desc).first })
    respond_to do |format|
      format.turbo_stream do render turbo_stream: turbo_stream.append("contact_details", @partial) end
      format.html
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

    @pagy, @contacts = pagy_nil_safe(params, Contact.untracked.order(archived_on: :desc), items: LIMIT)
    render_partial("contacts/untracked_contact", collection: @contacts, cached: false) if stale?(@contacts)
  end

  def update_touched
    authorize :contact, :touched?
    TouchedContact.call(@contact, current_user)
    if request.referrer.include? "groups"
      redirect_to batches_path(:batch_id => params[:batch_id], :contact_id => @contact.id), notice: "Contact has been touched." and return
    end
    redirect_to request.referrer, notice: "Contact has been touched."
  end

  def touched
    authorize :contact, :touched?
    TouchedContact.call(@contact, current_user)
    render turbo_stream: turbo_stream.remove(@contact)
  end

  def touch_back
    authorize :contact, :touch_back?
    UpdateTouchBack.call(@contact, current_user, params[:touch_back])
    @partial = render_to_string(partial: "contact/touch_back", locals: { contact: @contact }, formats: [:turbo_stream])
    respond_to do |format|
      format.turbo_stream do render turbo_stream: turbo_stream.append("touch-back", @partial) end
      format.html
    end
  end

  def untrack
    authorize :contact, :untrack?
    UpdateTouchBack.call(@contact, current_user, "do_not_track")
    render turbo_stream: turbo_stream.remove(@contact)
  end

  def track
    authorize @contact, :track?
    UpdateTouchBack.call(@contact, current_user, "30_days")
    redirect_to followups_path, notice: "Contact has been tracked."
  end

  private

  def should_add_more_contacts?
    params[:commit] == "Save And Add More"
  end

  def set_contact
    @contact ||= Contact.find(params[:id])
  end

  def file_params
    params.require(:contact).permit(:filename)
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :relation_id, :intro)
  end
end
