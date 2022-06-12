class Api::RatingPolicy < Api::BaseApiPolicy
  def new?
    true
  end

  def create?
    true
  end

  def index?
    true
  end
end
