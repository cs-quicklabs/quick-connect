class trackReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def untrack
    contact = Contact.find(element.dataset["contact-id"])
    contact.update!(track: false, untrack_on: Date.today)
    contact.events.create(user: actor, action: "untrack", action_for_context: "untracked contact", trackable: contact, action_context: "Untracked")
  end

end
