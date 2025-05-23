class Account::LifeEventsController < Account::BaseController
  before_action :set_relation, only: %i[ show edit update destroy ]

  def index
    authorize :account
    @life_events = LifeEvent.all.joins("INNER JOIN groups ON groups.id = life_events.group_id").order("groups.name ASC").order(:name).group_by(&:group)
    @groups = Group.all.where(category: "event").order(:name).decorate
    @life_event = LifeEvent.new
    fresh_when LifeEvent.all
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
                               turbo_stream.replace(LifeEvent.new, partial: "account/life_events/form", locals: { life_event: LifeEvent.new, message: "Life event was created successfully.", groups: Group.all.where(category: "event").order(:name).decorate })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(LifeEvent.new, partial: "account/life_events/form", locals: { life_event: @life_event, groups: Group.all.where(category: "event").order(:name).decorate }) }
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
    if @life_event
      return @life_event
    end
    @life_event ||= LifeEvent.find(params[:id])
  end

  def life_event_params
    params.require(:life_event).permit(:name, :group_id)
  end
end
