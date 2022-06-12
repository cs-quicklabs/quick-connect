class Api::AccountPolicy < Struct.new(:api_user, :account)
  def index?
    true
  end

  def edit?
    true
  end

  def create?
    true
  end

  def destroy?
    true
  end

  def update?
    true
  end

  def account?
    true
  end

  def preferences?
    true
  end

  def billings?
    true
  end

  def new?
    true
  end
end
