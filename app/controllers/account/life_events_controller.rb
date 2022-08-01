class Account::LifeEventsController < Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @life_events = LifeEvent.all.order(:name).group_by(&:group)
    @life_event = LifeEvent.new
  end

  def edit
    authorize :account
  end

  def create
    authorize :account

    @life_event = LifeEvent.new(life_event_params)
    respond_to do |format|
      if @life_event.save
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:life_events, partial: "account/life_events/life_event", locals: { life_event: @life_event }) +
                               turbo_stream.replace(LifeEvent.new, partial: "account/life_events/form", locals: { life_event: LifeEvent.new, message: "Life Event was created successfully." })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(LifeEvent.new, partial: "account/life_events/form", locals: { life_event: @life_event }) }
      end
    end
  end

  def update
    authorize :account
    respond_to do |format|
      if @life_event.update(life_event_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@life_event, partial: "account/life_events/life_event", locals: { life_event: @life_event, messages: nil }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@life_event, template: "account/life_events/edit", locals: { life_event: @life_event, messages: @life_event.errors.full_messages }) }
      end
    end
  end

  def destroy
    authorize :account

    @life_event.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@life_event) }
    end
  end

  private

  def set_relation
    @life_event ||= LifeEvent.find(params[:id])
  end

  def life_event_params
    params.require(:life_event).permit(:name, :group_id)
  end
end
