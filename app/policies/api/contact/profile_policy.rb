class Api::Contact::ProfilePolicy < Api::Contact::BaseContactPolicy
  def index?
    true
  end
end
