class DashboardController < BaseController
  def index
    authorize :dashboard
    contacts = current_user.contacts.available
    @favorites = contacts.favorites.first(10)
    @popular = contacts.popular.first(10)
    @recent = contacts.recent.first(10)
    fresh_when contacts
  end

  def events
    authorize :dashboard, :index?
    @events = Event.top_50_events
    fresh_when @events
  end

  def tasks
    authorize :dashboard, :index?
    @tasks = current_user.upcoming_tasks
    fresh_when @tasks
  end

  def reminders
    authorize :dashboard, :index?
    @upcoming_reminders = current_user.upcoming_reminders
    fresh_when @upcoming_reminders
  end
end
