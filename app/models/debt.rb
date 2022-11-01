class Debt < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date, :amount
  belongs_to :contact
  normalize_attribute :title, :amount, :with => :strip
  validates :amount, format: { with: /\A[ 0-9*#-.+ ]+\z/,
                               message: "should be in numbers" }
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
