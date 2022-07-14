class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation", "journal", "commented", "release_note", "conversation", "debt", "deleted", "gifted"].freeze
  acts_as_tenant :account
  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :eventable, polymorphic: true, optional: true
  validates_presence_of :action
  validates :action, inclusion: { in: ACTIONS }
end
