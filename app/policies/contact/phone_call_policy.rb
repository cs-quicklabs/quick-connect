class Contact::PhoneCallPolicy < Contact::BaseContactPolicy
  def index?
    phone_call = record.second
    return false if phone_call.contact.archived?
    phone_call.user == user
  end

  def create?
    phone_call = record.second
    return false if phone_call.contact.archived?
    phone_call.user == user
  end

  def edit?
    phone_call = record
    phone_call.user_id == user.id
  end

  def destroy?
    phone_call = record
    phone_call.user_id == user.id
  end
end
