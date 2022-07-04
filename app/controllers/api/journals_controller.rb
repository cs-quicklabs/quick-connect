class Api::JournalsController < Api::BaseController
  before_action :set_journal, only: %i[ show edit update destroy ]

  def index
    authorize [:api, Journal]
    @pagy, @journals = pagy_nil_safe(params, @api_user.journals.order(created_at: :desc), items: LIMIT)
    render json: { pagy: pagination_meta(pagy_metadata(@pagy)), success: true, data: @journals.as_json(:include => [:comments]), message: "Journals were successfully retrieved" }
  end

  def destroy
    authorize [:api, @journal]
    @journal = DestroyJournal.call(@api_user, @journal).result
    respond_to do |format|
      format.json { render json: { success: true, data: {}, message: "Journal was successfully deleted." } }
    end
  end

  def edit
    authorize [:api, @journal]
    render json: { success: true, data: @journal, message: "Edit journal" }
  end

  def show
    authorize [:api, @journal]
    render json: { success: true, data: @journal.as_json(:include => [:comments]), message: "" }
  end

  def update
    authorize [:api, @journal]
    respond_to do |format|
      Event.where(trackable: @journal).touch_all
      if @journal.update(journal_params)
        format.json { render json: { success: true, data: @journal, message: "Journal was successfully updated." } }
      else
        format.json { render json: { success: false, message: @journal.errors.full_messages.first } }
      end
    end
  end

  def create
    authorize [:api, Journal]
    @journal = AddJournal.call(journal_params, @api_user).result
    respond_to do |format|
      if @journal.errors.empty?
        format.json { render json: { success: true, data: @journal, message: "Journal was successfully created." } }
      else
        format.json { render json: { success: false, message: @journal.errors.full_messages.first } }
      end
    end
  end

  private

  def set_journal
    @journal = Journal.find(params["id"])
  end

  def journal_params
    params.require(:api_journal).permit(:title, :body)
  end
end
