class Api::CommentPolicy < Api::BaseApiPolicy
  def edit?
    return true
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def create?
    return true
  end

  def index?
    true
  end
end
