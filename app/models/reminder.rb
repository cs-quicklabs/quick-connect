class Reminder < ApplicationRecord
  validates_presence_of :title, :reminder_type, :reminder_date, :remind_after
  belongs_to :user
  belongs_to :contact
  enum reminder_type: [:once, :multiple]
  validates :title,
            :length => { :maximum => 25 }
  scope :once, -> { where(reminder_type: "once") }
  scope :multiple, -> { where(reminder_type: "multiple") }

  def reminder
    if status == "week"
      days = reminder_date + remind_after * 7.days
    elsif status == "year"
      days = reminder_date + remind_after * 365.days
    elsif status == "month"
      days = reminder_date + remind_after * 30.days
    end
    return reminder_needed = reminder_date + days
  end

  def upcoming
    num = 1
    upcomings = []
    loop do
      if self.status == "week"
        reminder_needed = self.reminder_date + self.remind_after * 7.days
      elsif status == "year"
        reminder_needed = self.reminder_date + self.remind_after * 365.days
      elsif status == "month"
        reminder_needed = self.reminder_date + self.remind_after * 30.days
      end
      binding.irb
      upcomings.push(reminder_needed)
      if reminder_needed > Date.today + 90.days
        break
      end
    end
    if self.reminder_type == "once"
      upcomings.push(self.reminder_date)
    end

    return upcomings
  end
end
