class Api::Contact::TimelinePolicy < Api::Contact::BaseContactPolicy
  def index?
    return true if record.second.user == user
  end
end
