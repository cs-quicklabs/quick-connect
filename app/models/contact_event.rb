class ContactEvent < ApplicationRecord
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  validates_presence_of :title, :body
  belongs_to :life_event, class_name: "LifeEvent", foreign_key: "life_event_id"
  belongs_to :user
  validates :title,
            :length => { :maximum => 25 }
  normalize_attribute :body, :title, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
end
