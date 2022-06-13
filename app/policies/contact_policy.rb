class ContactPolicy < ApplicationPolicy
  def update?
    return false if record.archived?
    return true if record.user = user
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
    return true if record.user = user
  end

  def password?
    true
  end

  def destroy?
    false
  end

  def archive_contact?
    true
  end

  def edit?
    return false if record.archived?
    return true if record.user = user
  end
end
