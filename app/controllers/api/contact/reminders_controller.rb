class Api::Contact::RemindersController < Api::Contact::BaseController
  before_action :set_reminder, only: %i[ show edit update destroy ]

  def index
    authorize [:api, @contact, Reminder]

    @reminder = Reminder.new
    @pagy, @reminders = pagy_nil_safe(params, @contact.reminders.order(created_at: :desc), items: LIMIT)

    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @reminders, message: "Contact reminders" }
  end

  def destroy
    authorize [:api, @contact, @reminder]

    @reminder = DestroyContactDetail.call(@contact, @api_user, @reminder).result
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Reminder was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @contact, @reminder]
    render json: { success: true, data: @reminder, message: " Edit Reminder" }
  end

  def update
    authorize [:api, @contact, @reminder]

    respond_to do |format|
      if @reminder.update(reminder_params)
        Event.where(trackable: @reminder).touch_all
        format.json { render json: { success: true, data: @reminder, message: "Reminder was successfully updated." } }
      else
        format.json { render json: { success: false, message: @reminder.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, @contact, Reminder]

    @reminder = AddReminder.call(reminder_params, @api_user, @contact).result
    respond_to do |format|
      if @reminder.persisted?
        format.json { render json: { success: true, data: @reminder, message: "Reminder was successfully created." } }
      else
        format.json { render json: { success: false, message: @reminder.errors.full_messages.first } }
      end
    end
  end

  private

  def set_reminder
    @reminder = Reminder.find(params["id"])
  end

  def reminder_params
    params.require(:api_reminder).permit(:title, :reminder_type, :remind_after, :comments, :reminder_date, :status)
  end
end
