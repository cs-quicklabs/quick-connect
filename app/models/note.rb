class Note < ApplicationRecord
  belongs_to :user
  validates_presence_of :body
  belongs_to :contact
  normalizes :body, with: ->(value) { value&.strip }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
