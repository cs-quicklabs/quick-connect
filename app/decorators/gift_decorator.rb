class GiftDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def display_status_color
    if self.status == "given"
      "blue"
    else
      "green"
    end
  end
end
