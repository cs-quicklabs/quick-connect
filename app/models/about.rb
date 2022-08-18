class About < ApplicationRecord
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  belongs_to :user
end
