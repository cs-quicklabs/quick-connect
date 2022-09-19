class BatchReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def show
    batch = Batch.find(element.dataset["batch-id"])
    contacts = batch.contacts.uniq
    html = render(partial: "batches/show", locals: { batch: batch, contacts: contacts })

    morph "#show1", "#{html}"
  end

  def contact
    contact = Contact.find(element.dataset["contact-id"])
    relatives = Relative.includes(:contact, :relation).where(first_contact_id: contact.id)
    html = render(partial: "batches/profile", locals: { contact: contact, relatives: relatives })

    morph "#profile", "<div id='profile'>#{html}</div>"
  end

  def add
    @contact = Contact.find(element.dataset["contact-id"])
    @batch = Batch.find(element.dataset["batch-id"])
    @batch = AddContactToGroup.call(@batch, current_user, @contact).result
    html = render(partial: "batches/contact", locals: { batch: @batch, contact: @contact })

    morph "#batch_contacts", "#{html}"
  end
end
