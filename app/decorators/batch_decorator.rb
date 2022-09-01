class BatchDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_name
    "#{name}".titleize
  end
end
