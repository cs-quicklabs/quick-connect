class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation", "commented", "conversation", "debt", "deleted", "gifted", "document", "contact_activity", "contact_event", "reminder", "about", "invited", "deactivated", "activated", "batch", "reminder", "about", "removed", "group", "track", "untrack", "imported", "touched", "collection", "deleted_collection"].freeze
  acts_as_tenant :account
  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :eventable, polymorphic: true, optional: true
  validates_presence_of :action
  validates :action, inclusion: { in: ACTIONS }
  default_scope { order(created_at: :desc) }
  scope :follow_up, -> { where(action: ["called", "conversation", "contact_activity", "contact_event"]) }
  scope :sanitize, -> { where.not("trackable_id IS NULL OR eventable_id IS NULL") }

  def relation_events
    Event.all.where trackable_type: "relative"
  end

  def self.top_50_events
    Event.all.includes(:eventable, :trackable, :user, :account).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end

  def self.query(params, includes = nil)
    return [] if params.empty?
    EventQuery.new(self.includes(includes), params).filter
  end

  ACTION_OPTIONS = [
    ["All", ""],
    ["Phone Calls", "called"],
    ["Conversations", "conversation"],
    ["Social Activities", "contact_activity"],
    ["Life Events", "contact_event"],
  ]
end
