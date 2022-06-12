class Api::Contact::BaseContactPolicy < Api::BaseApiPolicy
  def index?
    return false if record.second.archived?
    return true if record.second.user == user
  end

  def update?
    index?
  end

  def create?
    index?
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
