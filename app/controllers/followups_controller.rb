class FollowupsController < BaseController
  def index
    authorize :followup
  end
end
