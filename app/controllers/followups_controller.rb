class FollowupsController < BaseController
  def index
    authorize :followup
    followups = Contact.all.joins("INNER JOIN events ON contacts.id = events.eventable_id").select("contacts.*,events.created_at as event_create, events.action as event_action, events.trackable_id as event_track").where("events.action IN (?)", ["phone_call", "conversation", "contact_activity", "contact_event"])
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    followups.each do |followup|
      if Date.today >= followup.event_create && followup.event_create >= Date.today - 30.days
        @firsts += [followup]
      elsif Date.today - 30.days > followup.event_create && followup.event_create >= Date.today - 60.days
        @seconds += [followup]
      elsif Date.today - 60.days > followup.event_create && followup.event_create >= Date.today - 90.days
        @thirds += [followup]
      else
        @fourths += [followup]
      end
    end
  end
end
