class Journal < ApplicationRecord
  acts_as_tenant :account
  belongs_to :user
  validates_presence_of :title, :body
  has_many :comments, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  normalize_attribute :title, :body, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
