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
end
