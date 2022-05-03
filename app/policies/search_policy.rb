class SearchPolicy < Struct.new(:user, :search)

  def contacts?
    true
  end

end
