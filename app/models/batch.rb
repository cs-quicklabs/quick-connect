class Batch < ApplicationRecord
  acts_as_tenant :account
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_many :batches_contacts
  has_and_belongs_to_many :contacts, touch: true
  normalize_attribute :name, :with => :strip
  has_many :events, class_name: "Event", foreign_key: "trackable", dependent: :destroy
  validates :name, :allow_blank => false, :length => { :maximum => 25 }
end
