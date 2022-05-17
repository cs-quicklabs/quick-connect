class ContactReflex < ApplicationReflex
  def show
    contact = Contact.find(element.dataset["contact-id"])
    contacts = Contact.for_current_account.active.order(:first_name)
    relatives = Relative.includes(:contact, :relation).where(first_contact_id: contact.id)
    html = render(partial: "contacts/profile", locals: { contact: contact, contacts: contacts, relatives: relatives })

    morph "#profile", "<div id='profile'>#{html}</div>"
  end
end
