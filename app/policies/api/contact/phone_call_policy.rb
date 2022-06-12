class Api::Contact::PhoneCallPolicy < Api::Contact::BaseContactPolicy
  def index?
    true
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
