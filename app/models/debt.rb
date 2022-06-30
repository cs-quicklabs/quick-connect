class Debt < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date, :amount
  belongs_to :contact
  normalize_attribute :title, :amount, :with => :strip
end
