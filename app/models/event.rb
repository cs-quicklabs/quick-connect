class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "note", "call", "archived", "relation", "journal", "commented", "release_note", "conversation", "debt", "deleted"].freeze
  acts_as_tenant :account
  belongs_to :user
  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :eventable, polymorphic: true, optional: true
  validates_presence_of :user, :action
  validates :action, inclusion: { in: ACTIONS }
end
