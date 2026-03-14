class Document < ApplicationRecord
  belongs_to :user
  validates_presence_of :filename, :link
  belongs_to :contact
  normalizes :filename, :comments, :link, with: ->(value) { value&.strip }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
