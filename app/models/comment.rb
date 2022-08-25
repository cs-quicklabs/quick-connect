class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :journal
  validates_presence_of :title
  normalize_attribute :title, :with => :strip
end
