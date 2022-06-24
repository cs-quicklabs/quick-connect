class Api::ContactsPolicy < Struct.new(:user, :contacts)
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

  def unarchive_contact?
    true
  end

  def destroy?
    true
  end
end
