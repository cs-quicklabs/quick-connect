class ContactActivity < ApplicationRecord
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  belongs_to :activity, class_name: "Activity", foreign_key: "activity_id"
  validates_presence_of :title, :body
end
