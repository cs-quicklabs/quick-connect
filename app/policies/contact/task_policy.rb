class Contact::TaskPolicy < Contact::BaseContactPolicy
  def edit?
    return true if !record.second.completed
  end
end
