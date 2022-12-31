class ReleaseNote < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  has_rich_text :body
  scope :published, -> { where(published: true) }
  scope :draft, -> { where(published: false) }
  normalize_attribute :title, :body, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
