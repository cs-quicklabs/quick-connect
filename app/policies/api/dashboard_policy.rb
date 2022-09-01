class Api::DashboardPolicy < Api::BaseApiPolicy
  def index?
    true
  end

  def recents?
    true
  end

  def favorites?
    true
  end

  def upcomings?
    true
  end
end
