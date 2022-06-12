class Api::ContactPolicy < Api::BaseApiPolicy
  def update?
    return true if !record.last.archived
  end

  def unarchive_contact?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def show?
    return true if record.last.user == user
  end

  def profile?
    return true if !record.last.archived
  end

  def destroy?
    false
  end

  def archive_contact?
    true
  end

  def edit?
    return true if !record.last.archived
  end
end
