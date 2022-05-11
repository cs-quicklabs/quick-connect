class Contact::RelativePolicy < Contact::BaseContactPolicy

    def index?
        true
    end
    def create?
        true
    end
    def edit?
        relation=record
        relation.user_id == user.id
    end
    def destroy?
        relation=record
        relation.user_id == user.id
    end
end