class ContactDecorator < Draper::Decorator
  delegate_all

  decorates_association :manager

  def display_name
    "#{first_name} #{last_name}".titleize
  end

  def name
    display_name
  end

  def display_archived_on
    "#{archived_on}".to_date
  end

  def display_email
    "#{email}".downcase
  end

  def touch_back_color
    if self.touch_back_after == "30_days"
      "blue"
    elsif self.touch_back_after == "60_days"
      "indigo"
    elsif self.touch_back_after == "90_days"
      "green"
    elsif self.touch_back_after == "after_90_days"
      "yellow"
    else
      "red"
    end
  end

  def display_follow_up_after
    self.touch_back_after.gsub("_", " ")
  end
end
