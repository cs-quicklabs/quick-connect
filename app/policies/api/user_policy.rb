class Api::UserPolicy < Api::BaseApiPolicy
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

  def update_permission?
    true
  end
end
