class ContactReflex < ApplicationReflex
  delegate :current_user, to: :connection
def show
    contact = Contact.find(element.dataset["contact-id"])
    contacts = Contact.for_current_account.active.order(:first_name) 

       html = render(partial: "contacts/profile", locals: { contact: contact, contacts: contacts })
     
       morph "#profile", "<div id='profile'>#{html}</div>"
      end
    end     