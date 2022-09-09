class Api::CommentPolicy < Api::BaseApiPolicy
  def edit?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def create?
    true
  end

  def index?
    true
  end
end
