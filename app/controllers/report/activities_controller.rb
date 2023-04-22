class Report::ActivitiesController < Report::BaseController
  def index
    authorize :report
  end
end
