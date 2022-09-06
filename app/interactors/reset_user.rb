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
      delete_activities
      delete_life_events
      delete_relations
      delete_ratings
      delete_groups
      delete_invitations
    rescue Exception => e
      return false
    end
    true
  end

  private

  def delete_contacts
    Contact.all.destroy_all
  end

  def delete_journals
    Journal.all.delete_all
  end

  def delete_ratings
    Rating.all.destroy_all
  end

  def delete_events
    Event.all.destroy_all
  end

  def add_event
    user.events.create(user: user, action: "reset", action_for_context: " ")
  end

  def delete_labels
    Label.where(account_id: user.account.id).destroy_all
  end

  def delete_relations
    Relation.where(account_id: user.account.id, 'default': "f").delete_all
  end

  def delete_fields
    Field.where(account_id: user.account.id, 'default': "f").delete_all
  end

  def delete_activities
    Activity.where(account_id: user.account.id, 'default': "f").delete_all
  end

  def delete_life_events
    LifeEvent.where(account_id: user.account.id, 'default': "f").delete_all
  end

  def delete_groups
    Batch.where(account_id: user.account.id).delete_all
  end

  def delete_invitations
    Invitation.where(account_id: user.account.id).delete_all
    User.where(invited_by: user).delete_all
  end

  attr_reader :user
end
