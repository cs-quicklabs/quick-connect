class ReleaseNotePolicy < ApplicationPolicy
  def edit?
    return false if record.published?
    true
  end

  def update?
    edit?
  end

  def index?
    user.admin == "true"
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def show?
    index?
  end

  def destroy?
    index?
  end

  def release?
    true
  end
end
