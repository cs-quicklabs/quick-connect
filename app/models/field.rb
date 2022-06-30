class Field < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  scope :for_current_account, -> { where(account: Current.account) }
  has_many :conversations, dependent: :restrict_with_exception
  normalize_attribute :name, :protocol, :icon, :with => :strip
end
