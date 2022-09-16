class FollowupsController < BaseController
  def index
    authorize :followup
    followups = Contact.all.available.tracked.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*, events.created_at as event_create, events.action as event_action, events.trackable_id as event_track, events.trackable_type as event_type").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    followups.each do |followup|
      if !followup.event_type.constantize.where(id: followup.event_track).blank?
        if Date.today >= followup.event_create.to_date && followup.event_create.to_date >= Date.today - 30.days
          @firsts += [followup]
        elsif Date.today - followup.event_create.to_date && followup.event_create.to_date >= Date.today - 60.days
          @seconds += [followup]
        elsif Date.today - 60.days > followup.event_create.to_date && followup.event_create.to_date >= Date.today - 90.days
          @thirds += [followup]
        else
          @fourths += [followup]
        end
      end
    end
    render_partial("followups/card", collection: followups) if stale?(followups)
  end
end
