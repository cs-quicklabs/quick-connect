class CommentPolicy < ApplicationPolicy
  def edit?
    true
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def create?
    true
  end
end
