class Api::Contact::NotePolicy < Api::Contact::BaseContactPolicy
  def index?
<<<<<<< HEAD
    return true if record.second.user == user
    return false if record.second.archived?
  end

  def update?
    index?
=======
    true
  end

  def update?
    true
>>>>>>> 7d20d69 (issue fixed)
  end

  def create?
    true
  end

  def destroy?
<<<<<<< HEAD
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
=======
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
>>>>>>> 7d20d69 (issue fixed)
  end
end
