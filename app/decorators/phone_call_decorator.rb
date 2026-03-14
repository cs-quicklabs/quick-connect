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
      "border border-green-200 bg-green-100 text-green-800"
    else
      "border border-red-200 bg-red-100 text-red-800"
    end
  end
end
