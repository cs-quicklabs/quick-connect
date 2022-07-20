class ContactEvent < ApplicationRecord
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  belongs_to :life_event, class_name: "LifeEvent", foreign_key: "event_id"
  validates_presence_of :title, :body
end