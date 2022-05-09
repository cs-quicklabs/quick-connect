class ContactRelationReflex < ApplicationReflex
  def change
    contact = Contact.find(element.dataset["contact-id"])
    contact.update(relation_id: element.dataset["relation-id"])
    contact.save
    morph "#contact-relation", render(partial: "profile/relation", locals: { contact: contact, relation: contact.relation })
  end

  def remove
    contact = Contact.find(element.dataset["contact-id"]) 
    contact.update(relation_id: nil)
    contact.save!
    morph "#contact-relation", render(partial: "profile/relation", locals: { contact: contact, relation: contact.relation})
  end
end
