class Report::EventsController < Report::BaseController
  def index
    authorize :report

    @filters = EventFilter.new(event_filter_params)
    @events = entries(Event.sanitize.includes(:trackable, :eventable).query(event_filter_params))
    render_partial("report/events/event", collection: @events, cached: false)
  end

  private

  def entries(entries)
    if params[:format] == "csv"
      entries
    else
      entries
    end
  end

  def event_filter_params
    params.permit(*EventFilter::KEYS)
  end
end
