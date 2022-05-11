class Event < ApplicationRecord
    ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation"].freeze

    belongs_to :user
    belongs_to :trackable, polymorphic: true
    belongs_to :eventable, polymorphic: true
    validates_presence_of :trackable, :user
    validates :action, inclusion: { in: ACTIONS }
    end