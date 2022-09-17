class CalenderReflex < ApplicationReflex
  delegate :view_context, to: :controller

  def next
    month = element.dataset["current-month"].to_date
    current_month_year = month + 1.month
    @reminders = Reminder.all.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    upcoming = @upcoming_reminders.sort_by { |r| r.second[:reminder] }.group_by { |r| r.second[:reminder].beginning_of_month }
    morph "#upcoming", render(partial: "dashboard/upcoming", locals: { current_month_year: current_month_year.strftime("%B %Y"), current: current_month_year.strftime("%B"), upcoming: upcoming })
  end

  def prev
    month = element.dataset["current-month"].to_date
    current_month_year = month - 1.month
    @reminders = Reminder.all.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    upcoming = @upcoming_reminders.sort_by { |r| r.second[:reminder] }.group_by { |r| r.second[:reminder].beginning_of_month }
    morph "#upcoming", render(partial: "dashboard/upcoming", locals: { current_month_year: current_month_year.strftime("%B %Y"), current: current_month_year.strftime("%B"), upcoming: upcoming })
  end
end
