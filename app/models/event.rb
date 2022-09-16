class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation", "journal", "commented", "release_note", "conversation", "debt", "deleted", "gifted", "document", "contact_activity", "contact_event", "reminder", "about", "invited", "deactivated", "activated", "batch", "reminder", "about", "removed", "group", "track", "untrack"].freeze
  acts_as_tenant :account
  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :eventable, polymorphic: true, optional: true
  validates_presence_of :action
  validates :action, inclusion: { in: ACTIONS }

  def relation_events
    Event.all.where trackable_type: "relative"
  end
end
