class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date
  belongs_to :contact
  normalizes :title, :body, with: ->(value) { value&.strip }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
