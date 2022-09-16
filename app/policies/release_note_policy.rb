class ReleaseNotePolicy < ApplicationPolicy
  def update?
    return false if record.published?
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

  def edit?
    return false if record.published?
  end
end
