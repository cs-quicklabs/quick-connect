class Api::Contact::ProfilePolicy < Api::Contact::BaseContactPolicy
  def index?
    true
  end

  def label?
    true
  end

  def remove_label?
    true
  end

  def relation?
    true
  end

  def remove_relation?
    true
  end
end
