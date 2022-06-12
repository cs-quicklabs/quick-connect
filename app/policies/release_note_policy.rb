class ReleaseNotePolicy < ApplicationPolicy
  def update?
    return true if record.user == user
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
    return true if record.user == user
  end

  def edit?
    return true if record.user == user
  end
end
