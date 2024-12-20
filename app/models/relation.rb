class Relation < ApplicationRecord
  acts_as_tenant :account
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_many :relatives
  has_one :contact, class_name: "Contact", foreign_key: "relation"
  has_many :contacts, through: :relatives, dependent: :restrict_with_exception
  scope :for_current_account, -> { where(account: Current.account) }
  normalize_attribute :name, :with => :strip
end
