class RatingReflex < ApplicationReflex
  def add
    @rating = Rating.new(rating: element.dataset["rating-id"], user_id: element.dataset["user-id"])
    @rating.save!
    morph "#ratings", render(partial: "journals/ratings/form", locals: { rating: @rating })
  end
end
