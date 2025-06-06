class FollowupsController < BaseController
  def index
    authorize :followup
    follow_ups = current_user.follow_ups
    @firsts = follow_ups.first
    @seconds = follow_ups.second
    @thirds = follow_ups.third
    @fourths = follow_ups.fourth

    fresh_when follow_ups
  end
end
