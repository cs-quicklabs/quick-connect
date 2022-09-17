class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50)
    render json: { success: true, data: @events.as_json(:include => [:eventable, :trackable, :account, :user]), message: "Events were successfully retrieved." }
  end

  def recents
    authorize [:api, :dashboard]

    @contacted = Contact.all.available.tracked.includes(:events).where("events.action IN (?)", ["called", "conversation"]).where("events.trackable_id IS NOT NULL").order("events.created_at DESC").uniq.take(8)
    render json: { success: true, data: @contacted.sort_by { |r| r.trackable.created_at }.uniq { |r| r.eventable }.take(8).as_json(:include => [:eventable, :trackable]), message: "Recents were successfully retrieved." }
  end

  def favorites
    authorize [:api, :dashboard]
    @pagy, @favorites = pagy_nil_safe(params, Contact.all.available.favorites, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @favorites, message: "Favorites were successfully retrieved." }
  end

  def upcomings
    authorize [:api, :dashboard]
    @reminders = Reminder.all.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=? ", false)
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming_api
    end
    render json: { success: true, data: @upcoming_reminders.sort_by { |r| r.second[:reminder] }, message: "Recents were successfully retrieved." }
  end
end
