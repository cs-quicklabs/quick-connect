class Api::FollowupsController < Api::BaseController
  def index
    authorize [:api, :followup]
<<<<<<< HEAD
    followups = Contact.all.tracked.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*, events.created_at as event_create, events.action as event_action, events.trackable_id as event_track").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
=======
    followups = Contact.all.available.tracked.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*, events.created_at as event_create, events.action as event_action, events.trackable_id as event_track, events.trackable_type as event_type").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
>>>>>>> 44696d87 (need to work on test cases)
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    followups.each do |followup|
      if Date.today >= followup.event_create.to_date && followup.event_create.to_date >= Date.today - 30.days
        @firsts += [followup]
      elsif Date.today - 30.days > followup.event_create && followup.event_create >= Date.today - 60.days
        @seconds += [followup]
      elsif Date.today - 60.days > followup.event_create && followup.event_create >= Date.today - 90.days
        @thirds += [followup]
      else
        @fourths += [followup]
      end
    end
    render json: { success: true, firsts: @firsts, seconds: @seconds, thirds: @thirds, fourths: @fourths, message: "Follow ups were successfully retrieved" }
  end
end
