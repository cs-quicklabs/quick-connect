class ReportsPolicy < Struct.new(:user, :reports)
  def index?
    true
  end
end
