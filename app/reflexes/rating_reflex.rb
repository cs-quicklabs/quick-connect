class RatingReflex < ApplicationReflex
  def add
    @current_user = User.find(element.dataset["user-id"])
    @rating = Rating.new(rating: element.dataset["rating-id"], user_id: @current_user.id)
    @rating.save!
    @ratings_by_month = @current_user.ratings.where("date <= ? and date > ?", Date.today, Date.today - 6.months).order(date: :desc).group_by { |r| r.date.beginning_of_month }
    morph "#rating", render(partial: "journals/ratings/form", locals: { rating: @rating, ratings_by_month: @ratings_by_month })
  end
end
