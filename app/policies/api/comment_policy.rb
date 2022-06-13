class Api::CommentPolicy < Api::BaseApiPolicy
  def edit?
    return true if record.last.user = user
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def create?
    return true if record.last.user = user
  end

  def index?
    true
  end
end
