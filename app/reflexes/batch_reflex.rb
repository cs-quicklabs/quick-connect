class BatchReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def show
    batch = Batch.find(element.dataset["batch-id"])
    contacts = batch.contacts.where("contacts.archived=?", false).order(:first_name).uniq
    contact = contacts.first
    html = render(partial: "batches/show", locals: { batch: batch, contacts: contacts })
    if contacts.size > 0
      profile = render(partial: "batches/profile", locals: { contact: contacts.first, event: contact.last_event, call: contact.phone_calls.order(created_at: :desc).first })
    else
      profile = render(partial: "batches/profile", locals: { contact: "" })
    end
    morph "#show1", "#{html}"
    morph "#profile", "#{profile}"
  end

  def contact
    contact = Contact.find(element.dataset["contact-id"])
    @event = contact.last_event
    @call = contact.phone_calls.order(created_at: :desc).first
    html = render(partial: "batches/profile", locals: { contact: contact, event: @event, call: @call })
    morph "#profile", "#{html}"
  end

  def add
    @contact = Contact.find(element.dataset["contact-id"])
    @batch = Batch.find(element.dataset["batch-id"])
    @batch = AddContactToGroup.call(@batch, current_user, @contact).result
    @event = @contact.events.last_event
    @call = @contact.phone_calls.order(created_at: :desc).first
    html = render(partial: "batches/show", locals: { batch: @batch, contacts: @batch.contacts.includes(:batches_contacts).where("contacts.archived=?", false).order("batches_contacts.created_at DESC").uniq, message: "Contact added successfully to group" })
    profile = render(partial: "batches/profile", locals: { contact: @contact, event: @event, call: @call })
    morph "#show1", "#{html}"
    morph "#profile", "#{profile}"
  end

  def remove
    @batch = Batch.find(element.dataset["batch"])
    @contact = Contact.find(element.dataset["contact"])
    @batch = RemoveContactFromGroup.call(@batch, current_user, @contact).result
    html = render(partial: "batches/show", locals: { batch: @batch, contacts: @batch.contacts.includes(:batches_contacts).where("contacts.archived=?", false).order("batches_contacts.created_at DESC").uniq, message: "Contact deleted successfully from  group" })
    profile = render(partial: "batches/profile", locals: { contact: "" })
    morph "#show1", "#{html}"
    morph "#profile", "#{profile}"
  end

  def destroy
    @batch = Batch.find(element.dataset["batch"])
    @batch = DestroyGroup.call(current_user, @batch).result
    @batches = Batch.all.order(:name)
    batch = render(partial: "batches/batch", locals: { batches: @batches })
    html = render(partial: "batches/show", locals: { batch: [], contacts: [] })
    profile = render(partial: "batches/profile", locals: { contact: "" })
    morph "#batches", "#{batch}"
    morph "#show1", "#{html}"
    morph "#profile", "#{profile}"
  end

  def create
  end
end
