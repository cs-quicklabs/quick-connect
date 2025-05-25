class Contact::BaseContactPolicy < ApplicationPolicy
  def index?
    true
  end

  def update?
    !record.first.archived?
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

  def toggle?
    update?
  end
end
