class EventDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :eventable
  decorates_association :trackable

  def trackable_name
    if defined?(self.trackable.name)
      "#{self.trackable.name.upcase_first}"
    elsif defined?(self.trackable.title)
      "#{self.trackable.title.upcase_first}"
    else
      ""
    end
  end
end
