class Contact::NotePolicy < Contact::BaseContactPolicy

    def index?
        true
    end
    def create?
        true
    end
    def edit?
        note=record
        note.user_id == user.id
    end
    def destroy?
        note=record
        note.user_id == user.id
    end
end