class FollowUpsController < BaseController
  def index
    authorize :section
  end
end
