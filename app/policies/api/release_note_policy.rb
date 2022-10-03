class Api::ReleaseNotePolicy < Api::BaseApiPolicy
  def index?
    true
  end

  def release?
    true
  end

  def show?
    true
  end
end
