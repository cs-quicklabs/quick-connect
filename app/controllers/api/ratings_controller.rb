class Api::RatingsController < Api::BaseController
  require "date"

  def index
    authorize [:api, Rating]
    @rating = Rating.all.where("DATE(created_at) = ?", Date.today).first || ""
    @ratings_by_month = Rating.all.where("date <= ? and date > ?", Date.today, Date.today - 3.months).order(date: :desc).
      render json: { success: true, data: { ratings_by_month: @ratings_by_month, rating: @rating }, message: "Ratings were successfully retrieved" }
  end

  def create
    authorize [:api, Rating]
    @rating = Rating.new(rating_params)
    @rating.date = Date.today
    @rating.user = @api_user
    if @rating.save
      render json: { success: true, data: @rating, message: "Rating was successfully created" }
    else
      render json: { success: false, message: @rating.errors.full_messages.first }
    end
  end

  private

  def rating_params
    params.require(:api_rating).permit(:rating, :user_id)
  end
end
