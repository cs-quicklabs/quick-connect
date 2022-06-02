class Contact::TaskPolicy < Contact::BaseContactPolicy
  def index?
    true
  end

  def create?
    true
  end

  def edit?
    true
  end

  def destroy?
    true
  end

  def show?
    true
  end

  def status?
    true
  end
end
