class Api::FollowupsController < Api::BaseController
  def index
    authorize [:api, :followup]
    @firsts = current_user.follow_ups.first
    @seconds = current_user.follow_ups.second
    @thirds = current_user.follow_ups.third
    @fourths = current_user.follow_ups.fourth
    render json: { success: true, firsts: @firsts, seconds: @seconds, thirds: @thirds, fourths: @fourths, message: "Follow ups were successfully retrieved" } if stale?(current_user.follows)
  end
end
