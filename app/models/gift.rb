class Gift < ApplicationRecord
  belongs_to :user
  validates_presence_of :name, :date, :body, :status
  belongs_to :contact
  normalizes :name, :body, with: ->(value) { value&.strip }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
