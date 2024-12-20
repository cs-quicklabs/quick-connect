class ContactActivity < ApplicationRecord
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  belongs_to :user
  validates_presence_of :title, :body
  has_many :events, class_name: "Event", as: :trackable
  belongs_to :activity, class_name: "Activity", foreign_key: "activity_id"
  normalize_attribute :body, :title, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
