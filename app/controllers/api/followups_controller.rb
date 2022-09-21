class Api::FollowupsController < Api::BaseController
  def index
    authorize [:api, :followup]
    followups = Contact.all.available.tracked.includes(:events).where("events.action IN (?)", ["called", "conversation", "contact_activity", "contact_event"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq
    @firsts = []
    @seconds = []
    @thirds = []
    @fourths = []
    if followups.size > 0
      followups.each do |followup|
        event = followup.events.first
        if Date.today >= event.created_at.to_date && event.created_at.to_date >= Date.today - 30.days
          @firsts += [event.as_json(:include => [:eventable, :trackable])]
        elsif Date.today - 30.days - event.created_at.to_date && event.created_at.to_date >= Date.today - 60.days
          @seconds += [event.as_json(:include => [:eventable, :trackable])]
        elsif Date.today - 60.days > event.created_at.to_date && event.created_at.to_date >= Date.today - 90.days
          @thirds += [event.as_json(:include => [:eventable, :trackable])]
        else
          @fourths += [event.as_json(:include => [:eventable, :trackable])]
        end
        @pagy, @fourths = pagy_array_safe(params, @fourths, items: LIMIT)
      end
    end
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, firsts: @firsts, seconds: @seconds, thirds: @thirds, fourths: @fourths, message: "Follow ups were successfully retrieved" }
  end
end
