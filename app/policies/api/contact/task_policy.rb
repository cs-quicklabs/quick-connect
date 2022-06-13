class Api::Contact::TaskPolicy < Api::Contact::BaseContactPolicy
  def status?
    return false if record.second.archived?
    true
  end
end
