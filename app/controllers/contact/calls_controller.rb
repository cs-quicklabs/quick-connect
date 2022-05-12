class Contact::CallsController < Contact::BaseController
  before_action :set_call, only: %i[ show edit update destroy ]

  def index
    authorize [@contact, Call]

    @call = Call.new
    @pagy, @calls = pagy_nil_safe(params, @contact.calls.order(created_at: :desc), items: LIMIT)
    render_partial("calls/call", collection: @calls) if stale?(@calls)
  end

  def destroy
    authorize [@contact, @call]

    @call.destroy
    Event.where(trackable: @call).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@call) }
    end
  end

  def edit
    authorize [@contact, @call]
  end

  def show
    authorize [@contact, @call]
  end

  def update
    authorize [@contact, @call]

    respond_to do |format|
      if @call.update(call_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@call, partial: "Contact/calls/call", locals: { call: @call }) }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@call, template: "Contact/calls/edit", locals: { call: @call }) }
      end
    end
  end

  def create
    authorize [@contact, Call]

    @call = AddCall.call(call_params, current_user, @contact).result
    respond_to do |format|
      if @call.persisted?
        format.turbo_stream {
          render turbo_stream: turbo_stream.prepend(:calls, partial: "Contact/calls/call", locals: { call: @call }) +
                               turbo_stream.replace(Call.new, partial: "Contact/calls/form", locals: { call: Call.new })
        }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Call.new, partial: "calls/form", locals: { call: @call }) }
      end
    end
  end

  private

  def set_call
    @call = Call.find(params["id"])
  end

  def call_params
    params.require(:call).permit(:body)
  end
end
