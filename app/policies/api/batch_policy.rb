class Api::BatchPolicy < Api::BaseApiPolicy
  def update?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def index?
    true
  end

  def show?
    true
  end

  def destroy?
    true
  end

  def edit?
    true
  end

  def contacts?
    true
  end

  def add?
    true
  end

  def remove?
    true
  end
end
