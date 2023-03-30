class ContactReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def show(contact)
    contact = Contact.find(contact)
    contacts = Contact.for_current_account.available.order(:first_name)
    relatives = Relative.includes(:contact, :relation).where(first_contact_id: contact.id)
    @event = contact.events.order(created_at: :desc).first
    @call = contact.phone_calls.order(created_at: :desc).first
    html = render(partial: "contacts/profile", locals: { contact: contact, contacts: contacts, relatives: relatives, event: @event, call: @call })
    morph "#profile", "<div id='profile'>#{html}</div>"
  end

  def favorite
    contact = Contact.find(element.dataset["contact-id"])
    contact.update(favorite: !contact.favorite)
    morph "#contact-favorite", render(partial: "contact/title", locals: { contact: contact, contact_labels: contact.labels, event: @event, call: @call, labels: Label.all })
  end

  def phone
    contact = Contact.find(element.dataset["contact-id"])
    html = render(partial: "shared/phone", locals: { contact: contact })
    morph "#modal", "#{html}"
  end

  def export
    html = render(partial: "account/export/export")
    morph "#export", "#{html}"
  end
end
