class PhoneCall < ApplicationRecord
  belongs_to :user
  validates_presence_of :body
  belongs_to :contact
  normalize_attribute :body, :with => :strip
  scope :incoming, -> { where(status: "contact") }
  scope :outgoing, -> { where(status: "user") }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
