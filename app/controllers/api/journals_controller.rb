class Api::JournalsController < Api::BaseController
  before_action :set_journal, only: %i[ show edit update destroy ]
  require "date"

  def index
    @rating = @current_user.ratings.where("DATE(created_at) = ?", Date.today).first || ""
    if !@rating.blank?
      @ratings_by_month = @current_user.ratings.where("date <= ? and date > ?", @rating.date + 1, @rating.date - 6.months).order(date: :desc).group_by { |r| r.date.beginning_of_month }
    end
    @pagy, @journals = pagy_nil_safe(params, @user.journals.order(created_at: :desc), items: LIMIT)
    render json: { success: true, data: @journals.as_json(include: :comments), message: "Journals were successfully retrieved" }
  end

  def destroy
    @journal.destroy
    Event.where(trackable: @journal).touch_all #fixes cache issues in activity
    respond_to do |format|
      format.json { render json: { suceess: true, data: {}, message: "Journal was successfully destroyed." } }
    end
  end

  def edit
    render json: { suceess: true, data: @journal, message: "" }
  end

  def show
    render json: { suceess: true, data: @journal.as_json(include: :comments), message: "" }
  end

  def update
    respond_to do |format|
      if @journal.update(journal_params)
        format.json { render json: { suceess: true, data: @journal, message: "Journal was successfully updated." } }
      else
        format.json { render json: { suceess: false, data: @journal, message: @journal.errors } }
      end
    end
  end

  def create
    @journal = AddJournal.call(journal_params, @user).result
    respond_to do |format|
      if @journal.errors.empty?
        format.json { render json: { suceess: true, data: @journal, message: "Journal was successfully created." } }
      else
        format.json { render json: { suceess: false, data: @journal, message: @journal.errors } }
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
