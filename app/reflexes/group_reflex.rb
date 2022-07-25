class GroupReflex < ApplicationReflex
  def activity
    group = element.value
    contact = Contact.find(element.dataset["contact-id"])
    contact_activity = ContactActivity.new
    activities = Activity.where(group_id: group).decorate
    html = render(partial: "contact/contact_activities/form", locals: { activities: activities, contact_activity: contact_activity, contact: contact })

    morph "#activity", "#{html}"
  end

  def event
    group = element.value
    contact = Contact.find(element.dataset["contact-id"])
    contact_event = ContactEvent.new
    events = LifeEvent.where(group_id: group).decorate
    html = render(partial: "contact/contact_events/form", locals: { events: events, contact_event: contact_event, contact: contact })

    morph "#event", "#{html}"
  end
end
