class JournalPolicy < ApplicationPolicy
  def update?
    return true
  end

  def new?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def destroy?
    true
  end

  def comment?
    true
  end
end
