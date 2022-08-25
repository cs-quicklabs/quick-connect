class ReminderDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_status
    if self.status_week?
      "week"
    elsif self.status_month?
      "Month"
    else
      "Year"
    end
  end
end
