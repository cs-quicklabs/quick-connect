class Batch < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_and_belongs_to_many :contacts, touch: true
  normalize_attribute :name, :with => :strip
end
