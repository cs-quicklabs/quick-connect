class Api::Contact::TimelinePolicy < Api::Contact::BaseContactPolicy
  def index?
    return true if record.first.user == user
    return false if record.first.archived?
  end
end
