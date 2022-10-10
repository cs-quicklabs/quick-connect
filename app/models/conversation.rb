class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :contact
  belongs_to :field
  validates_presence_of :date, :body
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
  normalize_attribute :body, :with => :strip
end
