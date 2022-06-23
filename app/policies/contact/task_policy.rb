class Contact::TaskPolicy < Contact::BaseContactPolicy
  def edit?
    return true if !record.second.completed
  end

  def update?
    edit?
  end
end
