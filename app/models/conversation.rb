class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :contact
  belongs_to :field
  validates_presence_of :date, :body

  normalize_attribute :body, :with => :strip
  has_many :events, class_name: "Event", as: :trackable
end
