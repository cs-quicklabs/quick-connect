class Debt < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date, :amount
  belongs_to :contact
  normalize_attribute :title, :amount, :with => :strip
  validates :amount, format: { with: /\A[ 0-9*#-.+ ]+\z/,
                               message: "Allows only numbers" }
  validates :title,
            :length => { :maximum => 25 }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
