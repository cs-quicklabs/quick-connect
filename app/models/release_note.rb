class ReleaseNote < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  has_rich_text :body
  scope :published, -> { where(published: true) }
  normalize_attribute :title, :body, :with => :strip
end
