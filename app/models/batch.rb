class Batch < ApplicationRecord
  acts_as_tenant :account
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_and_belongs_to_many :batches_contacts, touch: true
  normalize_attribute :name, :with => :strip
  validates :name, :allow_blank => false, :length => { :maximum => 25 }
end
