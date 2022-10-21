class DashboardController < BaseController
  def index
    authorize :dashboard
    @reminders = current_user.reminders.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming
    end
    @upcoming_reminders = @upcoming_reminders.sort_by { |r| r.second[:reminder] }
    @contacted = (current_user.events.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "PhoneCall" }) +
                  current_user.events.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "Conversation" })).uniq { |r| r.eventable }.take(10)
    @tasks = current_user.tasks.joins(:contact).where("contacts.archived=?", false).order(created_at: :desc).limit(10)
    fresh_when @contacted + @tasks + @reminders
  end

  def events
    authorize :dashboard, :index?
    @events = current_user.events.includes(:eventable, :trackable, :user, :account).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
    fresh_when @events
  end
end
