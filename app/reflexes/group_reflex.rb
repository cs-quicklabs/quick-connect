class GroupReflex < ApplicationReflex
  def activity
    binding.irb
    group = element.value
    contact = Contact.find(element.dataset["contact-id"])
    contact_activity = ContactActivity.new
    if !group.nil?
      activities = Activity.all.where(group_id: group).decorate
    else
      activities = Activity.all
    end
    html = render(partial: "contact/contact_activities/form", locals: { activities: activities, contact_activity: contact_activity, contact: contact })

    morph "#activity", "#{html}"
  end

  def event
    group = element.value
    contact = Contact.find(element.dataset["contact-id"])
    contact_event = ContactEvent.new
    if !group.nil?
      events = LifeEvent.all.where(group_id: group).decorate
    else
      events = LifeEvent.all
    end
    html = render(partial: "contact/contact_events/form", locals: { events: events, contact_event: contact_event, contact: contact })

    morph "#event", "#{html}"
  end
end
