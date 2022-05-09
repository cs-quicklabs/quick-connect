class Contact::PhoneCallPolicy < Contact::BaseContactPolicy

    def index?
        true
    end
    def create?
        true
    end
    def edit?
        phone_call=record
        phone_call.user_id == user.id
    end
    def destroy?
        phone_call=record
        phone_call.user_id == user.id
    end
end