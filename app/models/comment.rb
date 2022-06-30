class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :journal
  normalize_attribute :title, :with => :strip
  validates_presence_of :title, :null => false
end
