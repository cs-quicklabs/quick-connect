class Contact::BaseContactPolicy < ApplicationPolicy
  def index?
    return false if record.first.archived?
    true
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
