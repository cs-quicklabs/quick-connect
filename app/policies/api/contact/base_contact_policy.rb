class Api::Contact::BaseContactPolicy < ApplicationPolicy
  def index?
    return true if record.second.user == user
    return false if record.second.archived?
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
