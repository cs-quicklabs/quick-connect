class RelationDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_name
    "#{name}".upcase_first
  end
end
