class Note < ApplicationRecord
  belongs_to :user
  validates_presence_of :body
  belongs_to :contact
  normalize_attribute :body, :with => :strip
end
