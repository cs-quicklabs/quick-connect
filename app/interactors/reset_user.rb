class ResetUser < Patterns::Service
  def initialize(user)
    @user = user
  end

  def call
    begin
      delete_events
      add_event
      delete_contacts
      delete_journals
      delete_labels
      delete_fields
      delete_relations
      delete_ratings
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

  def add_event
    user.events.create(user: user, action: "reset", action_for_context: " ")
  end

  def delete_labels
    Label.where(account_id: user.account.id).destroy_all
  end

  def delete_relations
    Relation.where("account_id=? AND 'default'=?", user.account.id, "true").destroy_all
  end

  def delete_fields
    Field.where("account_id=? AND 'default'=?", user.account.id, "true").destroy_all
  end

  attr_reader :user
end
