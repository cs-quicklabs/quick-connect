class CommentPolicy < ApplicationPolicy
  def edit?
    record.user == user
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
