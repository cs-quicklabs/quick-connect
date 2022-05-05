class Event < ApplicationRecord
    ACTIONS = ["activated", "freed", "created", "deactivated", "event", "noted", "called"].freeze

    belongs_to :user
    belongs_to :trackable, polymorphic: true
  
    validates_presence_of :trackable, :user
    validates :action, inclusion: { in: ACTIONS }
    end