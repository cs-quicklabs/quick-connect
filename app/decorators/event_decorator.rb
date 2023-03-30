class EventDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :eventable
  decorates_association :trackable

  def trackable_name
    if defined?("#{self.trackable.name}")
      "#{self.trackable.name.upcase_first}"
    else
      "#{self.trackable.title.upcase_first}"
    end
  end
end
