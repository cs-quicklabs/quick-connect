class TaskDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_title
    "#{title.upcase_first}"
  end

  def display_status
    self.completed? ? "green" : "blue"
  end
end
