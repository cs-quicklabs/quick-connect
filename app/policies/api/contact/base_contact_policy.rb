class Api::Contact::BaseContactPolicy < ApplicationPolicy
  def index?
    return false if record.second.archived?
    true
  end

  def update?
    edit?
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
    edit?
  end

  def new?
    index?
  end
end
