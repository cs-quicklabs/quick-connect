class Reminder < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :title, :reminder_type, :reminder_date, :remind_after
  belongs_to :user
  belongs_to :contact
  enum reminder_type: [:once, :multiple]
  enum status: [:week, :month, :year], _prefix: true
  scope :once, -> { where(reminder_type: "once") }
  scope :multiple, -> { where(reminder_type: "multiple") }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy

  def today
    num = 0
    todays = []
    loop do
      if self.once? && self.reminder_date >= Date.today
        reminder_needed = self.reminder_date
      elsif self.multiple? && self.status_week?
        reminder_needed = self.reminder_date + num * (self.remind_after + 7.days)
      elsif self.multiple? && self.status_month?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.month)
      elsif self.multiple? && self.status_year?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.year)
      else
        break
      end
      if (reminder_needed == Date.today)
        todays.push([self.as_json, "reminder": reminder_needed])
        break
      elsif (reminder_needed > Date.today)
        break
      else
        num += 1
      end
    end
    return todays
  end

  def upcoming
    num = 0
    upcomings = []
    loop do
      if self.once? && self.reminder_date >= Date.today
        reminder_needed = self.reminder_date
      elsif self.multiple? && self.status_week?
        reminder_needed = self.reminder_date + num * (self.remind_after + 7.days)
      elsif self.multiple? && self.status_month?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.months)
      elsif self.multiple? && self.status_year?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.years)
      else
        break
      end
      if (reminder_needed >= Date.today && reminder_needed < Date.today + 60.days)
        upcomings.push([self.as_json, "reminder": reminder_needed.to_date])
        break
      elsif (reminder_needed > Date.today + 60.days)
        break
      else
        num += 1
      end
    end
    return upcomings
  end

  def upcoming_api
    num = 0
    upcomings = []
    loop do
      if self.once? && self.reminder_date >= Date.today
        reminder_needed = self.reminder_date
      elsif self.multiple? && self.status_week?
        reminder_needed = self.reminder_date + num * (self.remind_after + 7.days)
      elsif self.multiple? && self.status_month?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.months)
      elsif self.multiple? && self.status_year?
        reminder_needed = self.reminder_date + num * (self.remind_after + 1.years)
      else
        break
      end
      if (reminder_needed >= Date.today && reminder_needed < Date.today + 60.days)
        upcomings.push([self.as_json(:include => [:contact]), "reminder": reminder_needed.to_date])
        break
      elsif (reminder_needed > Date.today + 60.days)
        break
      else
        num += 1
      end
    end
    return upcomings
  end
end
