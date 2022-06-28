class ReleaseNotePolicy < ApplicationPolicy
  def update?
    return false if record.published?
    return true if record.user = user
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
    edit?
  end

  def edit?
    return false if record.published?
    return true if record.user = user
  end
end
