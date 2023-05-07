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

  def display_follow_up_after
    if self.touch_back_after == "do_not_track"
      self.touch_back_after.gsub("_", " ").upcase_first
    else
      "Follow up after #{self.touch_back_after.gsub("_", " ").upcase_first}"
    end
  end
end
