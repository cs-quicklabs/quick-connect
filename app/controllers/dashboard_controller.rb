class DashboardController < BaseController
  def index
    authorize :dashboard
    @recents = Event.includes(:eventable, :trackable).where(action: ["conversation", "called", "contact_activity"]).order(created_at: :desc).limit(10)
    @reminders = current_user.reminders
    @reminders.each do |reminder|
      @upcoming_reminders.push(reminder.upcoming)
    end
    binding.irb
  end

  def events
    authorize :dashboard, :index?
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
