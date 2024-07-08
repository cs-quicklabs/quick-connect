class Collection < ApplicationRecord
  acts_as_tenant :account
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_and_belongs_to_many :batches, touch: true
  normalize_attribute :name, :with => :strip
  validates_presence_of :name
end
