class CollectionPolicy < ApplicationPolicy
  def create?
    true
  end

  def edit?
    true
  end

  def destroy?
    true
  end

  def update?
    true
  end

  def add_group?
    true
  end

  def remove_group?
    true
  end
end
