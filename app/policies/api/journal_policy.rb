class Api::JournalPolicy < Api::BaseApiPolicy
  def update?
    return true
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

  def comment?
    return true if record.last.user = user
  end

  def edit?
    return true if record.last.user = user
  end
end
