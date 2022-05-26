class Contact::LabelPolicy < Contact::BaseContactPolicy
  def index?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end
end
