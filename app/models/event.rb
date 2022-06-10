class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation", "journal", "commented", "release_note", "status"].freeze
  acts_as_tenant :account
  belongs_to :user
  belongs_to :trackable, polymorphic: true
  belongs_to :eventable, polymorphic: true
  validates_presence_of :trackable, :user, :action, :eventable
  validates :action, inclusion: { in: ACTIONS }
end
