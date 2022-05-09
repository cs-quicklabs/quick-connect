class Contact::TaskPolicy < Contact::BaseContactPolicy

    def index?
        true
    end
    def create?
        true
    end
    def edit?
        task=record
        task.user_id == user.id
    end
    def destroy?
        task=record
        task.user_id == user.id
    end
end