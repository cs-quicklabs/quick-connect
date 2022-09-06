class Api::SearchPolicy < Struct.new(:user, :search)
  def contacts?
    true
  end

  def relative?
    true
  end

  def add?
    true
  end
end
