class Api::Contact::TimelinePolicy < Api::Contact::BaseContactPolicy
  def index?
    return false if record.second.archived?
  end
end
