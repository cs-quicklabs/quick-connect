class Api::Contact::RelativePolicy < Api::Contact::BaseContactPolicy
  def index?
    return true if record.second.user == user
    return false if record.second.archived?
  end

  def update?
    index?
  end

  def create?
    true
  end

  def destroy?
    index?
  end

  def edit?
    index?
  end

  def show?
    index?
  end

  def new?
    index?
  end
end
