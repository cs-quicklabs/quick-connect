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
   contact = Contact.find(element.dataset["contact-id"])
   profile=Contact.find(element.dataset["profile-id"])
   form = ActionView::Helpers::FormBuilder.new(
      :relative, relative, view_context, {}
    )
   html = render(partial: "profile/relatives/search", locals: {form: form,  relation: contact,relative: relative,contact:profile})
 
   morph "#search", "<div id='contact_id'>#{html}</div>"
  end

  private

end
