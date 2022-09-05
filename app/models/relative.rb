class Relative < ApplicationRecord
  acts_as_tenant :account
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  belongs_to :first_contact, class_name: "Contact", foreign_key: "first_contact_id"
  belongs_to :relation, class_name: "Relation", foreign_key: "relation_id"
  validates :first_contact, uniqueness: { scope: :contact }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
