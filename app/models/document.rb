class Document < ApplicationRecord
  belongs_to :user
  validates_presence_of :filename, :link
  belongs_to :contact
  normalize_attribute :filename, :comments, :link, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
