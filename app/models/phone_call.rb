class PhoneCall < ApplicationRecord
  belongs_to :user
  validates_presence_of :body
  belongs_to :contact
  normalize_attribute :body, :with => :strip
  scope :incoming, -> { where(status: "contact") }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
  scope :outgoing, -> { where(status: "user") }
end
