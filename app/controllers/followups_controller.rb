class FollowupsController < BaseController
  def index
    authorize :followup
    @firsts = current_user.follow_ups.first
    @seconds = current_user.follow_ups.second
    @thirds = current_user.follow_ups.third
    @fourths = current_user.follow_ups.fourth
    fresh_when current_user.follows
  end
end
