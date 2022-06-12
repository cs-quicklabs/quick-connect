class Api::Contact::NotePolicy < Api::Contact::BaseContactPolicy
  def index?
    true
  end

  def update?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def edit?
    true
  end

  def show?
    true
  end

  def new?
    true
  end
end
