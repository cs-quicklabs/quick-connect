class Api::Contact::TimelinePolicy < Api::Contact::BaseContactPolicy
  def index?
    return true if record.second.user == user
    return false if record.second.archived?
  end
end
