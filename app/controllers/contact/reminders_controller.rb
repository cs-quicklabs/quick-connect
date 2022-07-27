class Contact::RemindersController < Contact::BaseController
  before_action :set_reminder, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Reminder]

    @reminder = Reminder.new
    @pagy, @reminders = pagy_nil_safe(params, @contact.reminders.order(created_at: :desc), items: LIMIT)
    render_partial("reminders/reminder", collection: @reminders) if stale?(@reminders)
  end

  def destroy
    authorize [@contact, @reminder]

    @reminder = DestroyContactDetail.call(@contact, current_user, @reminder).result
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@reminder) }
    end
  end

  def edit
    authorize [@contact, @reminder]
  end

  def show
    authorize [@contact, @reminder]
  end

  def update
    authorize [@contact, @reminder]

    respond_to do |format|
      if @reminder.update(reminder_params)
        Event.where(trackable: @reminder).touch_all
        format.html { redirect_to contact_reminders_path(@contact), notice: "Reminder was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@reminder, template: "contact/reminders/edit", locals: { reminder: @reminder }) }
      end
    end
  end

  def create
    authorize [@contact, Reminder]

    @reminder = AddReminder.call(reminder_params, current_user, @contact).result
    respond_to do |format|
      if @reminder.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:reminders, partial: "contact/reminders/reminder", locals: { reminder: @reminder }) +
                               turbo_stream.replace(Reminder.new, partial: "contact/reminders/form", locals: { reminder: Reminder.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Reminder.new, partial: "contact/reminders/form", locals: { reminder: @reminder }) }
      end
    end
  end

  private

  def set_reminder
    @reminder = Reminder.find(params["id"])
  end

  def reminder_params
    params.require(:reminder).permit(:title, :reminder_type, :remind_after, :comments, :reminder_date, :status)
  end
end
