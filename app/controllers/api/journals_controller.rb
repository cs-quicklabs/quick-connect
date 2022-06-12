class Api::JournalsController < Api::BaseController
  before_action :set_journal, only: %i[ show edit update destroy ]

  def index
    authorize [:api, Journal]
    @pagy, @journals = pagy_nil_safe(params, Journal.all.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @journals.as_json(:include => [:comments, :body]), message: "Journals were successfully retrieved" }
  end

  def destroy
    authorize [:api, @journal]
    @journal.destroy
    Event.where(trackable: @journal).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { suceess: true, data: {}, message: "Journal was successfully destroyed." } }
    end
  end

  def edit
    authorize [:api, @journal]
    render json: { suceess: true, data: @journal, message: "" }
  end

  def show
    authorize [:api, @journal]
    render json: { suceess: true, data: @journal.as_json(:include => [:comments, :body]), message: "" }
  end

  def update
    authorize [:api, @journal]
    respond_to do |format|
      if @journal.update(journal_params)
        format.json { render json: { suceess: true, data: @journal, message: "Journal was successfully updated." } }
      else
        format.json { render json: { suceess: false, data: @journal, message: @journal.errors.full_messages } }
      end
    end
  end

  def create
    authorize [:api, Journal]
    @journal = AddJournal.call(journal_params, @api_user).result
    respond_to do |format|
      if @journal.errors.empty?
        format.json { render json: { suceess: true, data: @journal, message: "Journal was successfully created." } }
      else
        format.json { render json: { suceess: false, data: @journal, message: @journal.errors.full_messages } }
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
