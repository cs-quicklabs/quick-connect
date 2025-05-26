class ContactLabelsReflex < ApplicationReflex
  def change
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels << Label.find(element.dataset["label-id"])
    @event = contact.events.order(created_at: :desc).first
    @call = contact.phone_calls.order(created_at: :desc).first
    contact.touch
    morph "#contact-labels", render(partial: "contact/labels", locals: { contact_labels: contact.labels, contact: contact, event: @event, call: @call, labels: Label.all })
  end

  def remove
    contact = Contact.find(element.dataset["contact-id"])
    contact.labels.destroy Label.find(element.dataset["label-id"])
    @event = contact.events.order(created_at: :desc).first
    @call = contact.phone_calls.order(created_at: :desc).first
    contact.touch
    morph "#contact-labels", render(partial: "contact/labels", locals: { contact_labels: contact.labels, contact: contact, event: @event, call: @call, labels: Label.all })
  end
end
