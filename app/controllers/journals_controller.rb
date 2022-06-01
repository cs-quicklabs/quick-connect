class JournalsController < BaseController
  before_action :set_tournal, only: %i[ show edit update destroy ]

  def index
    authorize Journal

    @pagy, @journals = pagy_nil_safe(params, Journal.order(created_at: :desc), items: LIMIT)
    render_partial("journals/journal", collection: @journals) if stale?(@journals)
  end

  def destroy
    authorize @journal

    @journal.destroy
    Event.where(trackable: @journal).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.turbo_stream { redirect_to journals_path, notice: "Journal was successfully removed." }
    end
  end

  def new
    authorize Journal
    @journal = Journal.new
  end

  def edit
    authorize @journal
  end

  def show
    authorize @journal
    @comment = Comment.new
    @comments = @journal.comments.order(created_at: :desc)
  end

  def update
    authorize @journal
    respond_to do |format|
      if @journal.update(journal_params)
        format.html { redirect_to journals_path, notice: "Journal was successfully updated." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@journal, partial: "journals/form", locals: { journal: @journal, title: "Edit Journal", subtitle: "Please update existing journal" }) }
      end
    end
  end

  def create
    authorize Journal

    @journal = AddJournal.call(journal_params, current_user).result
    respond_to do |format|
      if @journal.errors.empty?
        format.html { redirect_to journals_path, notice: "Journal was successfully created." }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace(Journal.new, partial: "journals/form", locals: { journal: @journal, title: "Add New Journal", subtitle: "Please add journal" }) }
      end
    end
  end

  private

  def set_tournal
    @journal = Journal.find(params["id"])
  end

  def journal_params
    params.require(:journal).permit(:title, :body)
  end
end
