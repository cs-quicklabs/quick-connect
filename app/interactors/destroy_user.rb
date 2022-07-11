class DestroyUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    begin
      delete_journals
      delete_ratings
      delete_events
      delete_contacts
      add_event
      user.destroy
      add_event
    rescue Exception => e
      return false
    end
    true
  end

  private

  def delete_contacts
    Contact.where(user: user).delete_all
  end

  def delete_journals
    Journal.where(user: user).delete_all
  end

  def delete_ratings
    Rating.where(user: user).delete_all
  end

  def delete_events
    Event.where(user_id: user.id).delete_all
    Event.where(trackable_id: user.id).delete_all
  end

  def add_event
    Event.create(action: "deleted", action_for_context: "deleted a user")
  end

  attr_reader :user
end
