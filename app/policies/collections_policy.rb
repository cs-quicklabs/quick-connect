class CollectionsPolicy < ApplicationPolicy
  def index?
    true
  end

  def add_group?
    true
  end

  def remove_group?
    true
  end

  def create?
    true
  end
end
