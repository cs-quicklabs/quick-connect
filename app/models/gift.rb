class Gift < ApplicationRecord
  belongs_to :user
  validates_presence_of :name, :date, :body, :status
  belongs_to :contact
  normalize_attribute :name, :body, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
