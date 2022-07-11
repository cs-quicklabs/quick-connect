class ResetUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    transfer_contacts
    transfer_journals
    transfer_ratings
    delete_events
    add_event
    begin
    rescue Exception => e
      return false
    end
    true
  end

  private

  def transfer_contacts
    Contact.where(user: user).delete_all
  end

  def transfer_journals
    Journal.where(user: user).delete_all
  end

  def transfer_ratings
    Rating.where(user: user).delete_all
  end

  def delete_events
    Event.where(user_id: user.id).delete_all
    Event.where(trackable_id: user.id).delete_all
  end

  def add_event
    user.events.create(user: user, action: "reset", action_for_context: "your account was reset")
  end

  attr_reader :user
end
