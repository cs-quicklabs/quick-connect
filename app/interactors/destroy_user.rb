class DestroyUser < Patterns::Service
  def initialize(user)
    @user = user
    @transferred_to = Preference.transfer_data_to_admin(user.account)
  end

  def call

    begin
      transfer_contacts
      transfer_journals
      transfer_comments
      transfer_ratings
      delete_events
      add_event
      user.destroy
      add_event

    rescue Exception => e
      return false
    end
    true
  end

  private

  def transfer_contacts
    Contact.where(user: user).update_all(user_id: transferred_to.id, account_id: transferred_to.id)
  end

  def transfer_journals
    Journal.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_comments
    Comment.where(user: user).update_all(user_id: transferred_to.id)
  end

  def transfer_ratings
    Rating.where(user: user).update_all(user_id: transferred_to.id)
  end

  def delete_events
    Event.where(user_id: user.id).delete_all
    Event.where(trackable_id: user.id).delete_all
  end

  def add_event
    Event.create(action: "deleted", action_for_context: "deleted a user")
  end

  attr_reader :user, :transferred_to
end
