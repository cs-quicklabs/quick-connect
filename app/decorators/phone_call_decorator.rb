class PhoneCallDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_status
    if self.status == "contact"
      "Incoming"
    else
      "Outgoing"
    end
  end

  def display_status_color
    if self.status == "contact"
      "green"
    else
      "red"
    end
  end
end
