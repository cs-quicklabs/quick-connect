class ContactLabelsReflex < ApplicationReflex
  def change
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels << Label.find(element.dataset["label-id"])
    contact.touch
    morph "#contact-labels", render(partial: "contact/labels", locals: { contact: contact, labels: contact.labels })
    morph "#labels", render(partial: "contact/title", locals: { contact_labels: contact.labels, contact: contact })
  end

  def remove
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels.destroy Label.find(element.dataset["label-id"])
    contact.touch
    morph "#contact-labels", render(partial: "contact/labels", locals: { contact: contact, labels: contact.labels })
    morph "#labels", render(partial: "contact/title", locals: { contact_labels: contact.labels, contact: contact })
  end
end
