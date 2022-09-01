class Contact::AboutPolicy < Contact::BaseContactPolicy
  def update?
    true
  end

  def index?
    true
  end
end
