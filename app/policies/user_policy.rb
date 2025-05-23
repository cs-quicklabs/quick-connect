class UserPolicy < ApplicationPolicy
  def update?
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
    true
  end

  def password?
    true
  end

  def preferences?
    true
  end

  def update_password?
    true
  end

  def reset?
    true
  end

  def destroy?
    true
  end

  def toggle_email_notifications?
    true
  end
end
