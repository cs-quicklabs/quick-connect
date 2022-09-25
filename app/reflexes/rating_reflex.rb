class RatingReflex < ApplicationReflex
  delegate :current_user, to: :connection

  def add
    @current_user = User.find(element.dataset["user-id"])
    @rating = Rating.new(rating: element.dataset["rating-id"], user_id: @current_user.id)
    @rating.save!
    @ratings_by_date = @current_user.ratings.where("date <= ? and date > ?", Date.today, Date.today - 3.months).order(date: :asc).group_by { |r| r.date.strftime("%B") }
    morph "#rating", render(partial: "journals/ratings_form", locals: { rating: @rating, ratings_by_date: @ratings_by_date })
  end
end
