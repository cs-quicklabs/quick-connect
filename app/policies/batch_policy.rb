class BatchPolicy < ApplicationPolicy
  def update?
    return true if record.user = user
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
    return true if record.user = user
  end

  def destroy?
    return true if record.user = user
  end

  def edit?
    return true if record.user = user
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
