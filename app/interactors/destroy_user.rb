class DestroyUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    delete_events
    add_event
    delete_journals
    delete_labels
    delete_fields
    delete_relations
    delete_ratings
    delete_contacts
    user.destroy
    begin
    rescue Exception => e
      return false
    end
    true
  end

  private

  def delete_contacts
    Contact.where(user: user).destroy_all
  end

  def delete_journals
    Journal.where(user: user).destroy_all
  end

  def delete_ratings
    Rating.where(user: user).destroy_all
  end

  def delete_events
    Event.where(user_id: user.id).destroy_all
    Event.where(trackable_id: user.id).destroy_all
  end

  def delete_labels
    Label.where(account: user.account).destroy_all
  end

  def delete_relations
    Relation.where(account: user.account).destroy_all
  end

  def delete_fields
    Field.where(account: user.account).destroy_all
  end

  def add_event
    Event.create(action: "deleted", action_for_context: "deleted a user")
  end

  attr_reader :user
end
