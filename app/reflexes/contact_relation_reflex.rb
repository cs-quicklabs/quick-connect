class ContactRelationReflex < ApplicationReflex
  delegate :view_context, to: :controller
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

  def add
relative=Relative.new
   id= element.dataset["contact-id"]
 
   form = ActionView::Helpers::FormBuilder.new(
      :relative, relative, view_context, {}
    )
   html = render(partial: "profile/relatives/form", locals: {form: form,  contact_id: id})
 
   morph "#contact_id", "<div id='contact_id'>#{html}</div>"
  end

  private

end
