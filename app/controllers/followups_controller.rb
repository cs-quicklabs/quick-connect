class FollowupsController < BaseController
  def index
    authorize :followup
    followups = Contact.all.available.tracked.includes(:events).where("events.action IN (?)", ["called", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    if followups.size > 0
      followups.each do |followup|
        event = followup.events.first
        if Date.today >= event.created_at.to_date && event.created_at.to_date >= Date.today - 30.days
          @firsts += [event]
        elsif Date.today - 30.days - event.created_at.to_date && event.created_at.to_date >= Date.today - 60.days
          @seconds += [event]
        elsif Date.today - 60.days > event.created_at.to_date && event.created_at.to_date >= Date.today - 90.days
          @thirds += [event]
        else
          @fourths += [event]
        end
      end
    end
    render_partial("followups/card", collection: followups) if stale?(followups)
  end
end
