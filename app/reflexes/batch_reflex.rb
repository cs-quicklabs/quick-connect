class BatchReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    @contact = Contact.find(element.dataset["contact-id"])
    @batch = Batch.find(element.dataset["batch-id"])
    @batch = AddContactToGroup.call(@batch, current_user, @contact).result
    @event = @contact.events.sanitize.first
    @call = @contact.phone_calls.order(created_at: :desc).first

    html = render(partial: "batches/show", locals: { batch: @batch, contacts: @batch.contacts.includes(:batches_contacts).where("contacts.archived=?", false).order("batches_contacts.created_at DESC").uniq, message: "Contact added successfully to group" })
    profile = render(partial: "batches/profile", locals: { contact: @contact, event: @event, call: @call, group_id: @batch.id })
    morph "#show1", "#{html}"
    morph "#profile", "#{profile}"
  end
end
