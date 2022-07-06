class Conversation < ApplicationRecord
  belongs_to :user
  validates_presence_of :date, :body
  belongs_to :field
  belongs_to :contact
  normalize_attribute :body, :with => :strip
end
