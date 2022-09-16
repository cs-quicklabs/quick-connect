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
    return true if !record.last.archived
  end

  def profile?
    return true if !record.last.archived
  end

  def destroy?
    true
  end

  def archive_contact?
    true
  end

  def edit?
    return true if !record.last.archived
  end

  def archived?
    true
  end

  def untracked_contact?
    true
  end

  def untrack?
    true
  end

  def track?
    true
  end
end
