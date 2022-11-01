class Api::DashboardController < Api::BaseController
  def index
    authorize [:api, :dashboard]
    @events = Event.all.includes(:eventable, :trackable).where("user_id IS NOT NULL").order(created_at: :desc).limit(50)
    render json: { success: true, data: @events.as_json(:include => [:eventable, :trackable, :account, :user]), message: "Events were successfully retrieved." }
  end

  def recents
    authorize [:api, :dashboard]

    @contacted = Event.joins("INNER JOIN phone_calls ON phone_calls.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "PhoneCall" }) +
                 Event.joins("INNER JOIN conversations ON conversations.id = events.trackable_id").joins("INNER JOIN contacts ON contacts.id = events.eventable_id").where("contacts.archived=?", false).where(events: { trackable_type: "Conversation" })
    render json: { success: true, data: @contacted.uniq { |r| r.eventable }.take(8).as_json(:include => [:eventable, :trackable]), message: "Recents were successfully retrieved." } if stale?(@contacted)
  end

  def favorites
    authorize [:api, :dashboard]
    @pagy, @favorites = pagy_nil_safe(params, Contact.all.available.favorites, items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @favorites, message: "Favorites were successfully retrieved." } if stale?(@favorites)
  end

  def upcomings
    authorize [:api, :dashboard]
    @reminders = @api_user.reminders.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=? ", false)
    @upcoming_reminders = []
    @reminders.each do |reminder|
      @upcoming_reminders += reminder.upcoming_api
    end
    render json: { success: true, data: @upcoming_reminders.sort_by { |r| r.second[:reminder] }, message: "Recents were successfully retrieved." } if stale?(@reminders)
  end
end
