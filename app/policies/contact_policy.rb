class ContactPolicy < ApplicationPolicy
  def update?
    return false if record.archived?
    true
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
    true
  end

  def profile?
    return false if record.archived?
    true
  end

  def password?
    true
  end

  def destroy?
    true
  end

  def archive_contact?
    true
  end

  def edit?
    return false if record.archived?
    true
  end

  def untracked_contact?
    true
  end

  def track?
    true
  end

  def untrack?
    true
  end

  def import?
    true
  end
end
