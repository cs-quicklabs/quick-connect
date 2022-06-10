module RatingHelper
  def rating_color(rating)
    bg_color = "bg-gray-100"
    text_color = "text-gray-800"

    if rating.awesome?
      bg_color = "bg-green-800"
      text_color = "text-green-400"
    elsif rating.normal?
      bg_color = "bg-red-100"
      text_color = "text-green-600"
    elsif rating.poor?
      bg_color = "bg-red-100"
      text_color = "text-green-800"
    end
    bg_color + " " + text_color
  end

  def emoticon
    awesome = ""
  end
end
