class SearchPolicy < Struct.new(:user, :search)
  def contacts?
    true
  end

  def contact?
    true
  end

  def add?
    true
  end

  def nav?
    true
  end
end
