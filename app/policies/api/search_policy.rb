class Api::SearchPolicy < Struct.new(:user, :search)
  def contacts?
    true
  end

  def contact?
    true
  end
end
