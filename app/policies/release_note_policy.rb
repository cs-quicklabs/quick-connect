class ReleaseNotePolicy < ApplicationPolicy
  def create?
    user.admin == "true"
  end

  def edit?
    !record.published? && create?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end

  def release?
    true
  end

  def whatsnew?
    true
  end
end
