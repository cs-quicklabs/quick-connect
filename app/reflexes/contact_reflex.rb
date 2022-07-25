class ContactReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def show
    contact = Contact.find(element.dataset["contact-id"])
    contacts = Contact.for_current_account.available.order(:first_name)
    relatives = Relative.includes(:contact, :relation).where(first_contact_id: contact.id)
    html = render(partial: "contacts/profile", locals: { contact: contact, contacts: contacts, relatives: relatives })

    morph "#profile", "<div id='profile'>#{html}</div>"
  end

  def favorite
    contact = Contact.find(element.dataset["contact-id"])
    contact.update(favorite: !contact.favorite)
    morph "#contact-favorite", render(partial: "contact/title", locals: { contact: contact })
  end
end
