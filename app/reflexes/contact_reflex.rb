class ContactReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def favorite
    contact = Contact.find(element.dataset["contact-id"])
    contact.update(favorite: !contact.favorite)
    morph "#contact-favorite", render(partial: "contact/favorite", locals: { contact: contact })
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
