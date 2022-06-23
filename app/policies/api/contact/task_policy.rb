class Api::Contact::TaskPolicy < Api::Contact::BaseContactPolicy
  def edit?
    return true if !record.third.completed
  end

  def update?
    edit?
  end
end
