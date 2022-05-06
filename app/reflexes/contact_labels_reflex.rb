class ContactLabelsReflex < ApplicationReflex
  def change
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels << Label.find(element.dataset["label-id"])
    morph "#contact-labels", render(partial: "profile/labels", locals: { contact: contact, labels: contact.labels })
  end

  def remove
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels.destroy Label.find(element.dataset["label-id"])

    morph "#contact-labels", render(partial: "profile/labels", locals: { contact: contact, labels: contact.labels })
  end
end
