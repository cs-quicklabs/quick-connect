class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
