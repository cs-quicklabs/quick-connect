class ReportPolicy < Struct.new(:user, :report)
  def index?
    true
  end

  def weekly?
    true
  end

  def monthly?
    true
  end

  def yearly?
    true
  end
end
