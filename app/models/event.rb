class Event < ApplicationRecord
  ACTIONS = ["created", "task", "unarchived", "event", "noted", "called", "archived", "relation", "journal", "commented", "conversation", "debt", "deleted", "gifted", "document", "contact_activity", "contact_event", "reminder", "about", "invited", "deactivated", "activated", "batch", "reminder", "about", "removed", "group", "track", "untrack", "imported"].freeze
  acts_as_tenant :account
  belongs_to :user, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  belongs_to :eventable, polymorphic: true, optional: true
  validates_presence_of :action
  validates :action, inclusion: { in: ACTIONS }
  default_scope { order(created_at: :desc) }
  scope :follow_up, -> { where(action: ["called", "conversation", "contact_activity", "contact_event"]) }
  scope :sanitize, -> { where.not("trackable_id IS NULL") }

  def relation_events
    Event.all.where trackable_type: "relative"
  end

  def self.top_50_events
    Event.all.includes(:eventable, :trackable, :user, :account).where("user_id IS NOT NULL").order(created_at: :desc).limit(50).decorate
  end
end
