class Comment < ApplicationRecord
  enum status: [:regress, :stale, :progress]

  belongs_to :user
  belongs_to :journal
  validates_presence_of :title
  normalize_attribute :title, :with => :strip
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
