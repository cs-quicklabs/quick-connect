class Api::DashboardPolicy < Api::BaseApiPolicy
  def index?
    true
  end
end
