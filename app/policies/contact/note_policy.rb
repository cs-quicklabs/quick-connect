class Contact::NotePolicy < Contact::BaseContactPolicy
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
end
