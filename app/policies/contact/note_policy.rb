class Contact::NotePolicy < Contact::BaseContactPolicy
  def index?
    note = record.second
    return false if note.contact.archived?
    note.user == user
  end

  def create?
    note = record.second
    return false if note.contact.archived?
    note.user == user
  end

  def edit?
    note = record
    note.user == user
  end

  def destroy?
    note = record
    note.user == user
  end
end
