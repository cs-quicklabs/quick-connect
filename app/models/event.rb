class Event < ApplicationRecord
    ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived"].freeze

    belongs_to :user
    belongs_to :trackable, polymorphic: true
  
    validates_presence_of :trackable, :user
    validates :action, inclusion: { in: ACTIONS }
    end