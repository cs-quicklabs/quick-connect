class Conversation < ApplicationRecord
  belongs_to :user
  validates_presence_of :body, :date, :field_id
  belongs_to :field
  belongs_to :contact
  normalize_attribute :body, :with => :strip
end
