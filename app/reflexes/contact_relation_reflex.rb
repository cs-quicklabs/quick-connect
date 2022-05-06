class ContactRelationReflex < ApplicationReflex
  def change
    contact = Contact.find(element.dataset["contact-id"])
    contact.relations << Relation.find(element.dataset["relation-id"])
    morph "#contact-relation", render(partial: "profile/relation", locals: { contact: contact, relations: contact.relations })
  end

  def remove
    contact = Contact.find(element.dataset["contact-id"]) 
    contact.relations.destroy Relation.find(element.dataset["relation-id"])
    morph "#contact-relation", render(partial: "profile/relation", locals: { contact: contact, relations: contact.relations})
  end
end
