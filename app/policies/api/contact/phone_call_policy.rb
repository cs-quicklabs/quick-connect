class Api::Contact::PhoneCallPolicy < Api::Contact::BaseContactPolicy
  def index?
<<<<<<< HEAD
    return true if record.second.user == user
    return false if record.second.archived?
=======
    true
>>>>>>> 7d20d69 (issue fixed)
  end

  def update?
    index?
  end

  def create?
    true
  end

  def destroy?
    index?
  end

  def edit?
    index?
  end

  def show?
    index?
  end

  def new?
    index?
  end
end
