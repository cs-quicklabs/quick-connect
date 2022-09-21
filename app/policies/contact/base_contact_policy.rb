class Contact::BaseContactPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    return false if record.first.archived?
    true
  end

  def create?
    update?
  end

  def destroy?
    update?
  end

  def edit?
    update?
  end

  def show?
    index?
  end

  def new?
    create?
  end
end
