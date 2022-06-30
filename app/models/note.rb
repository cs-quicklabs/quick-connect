class Note < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
end
