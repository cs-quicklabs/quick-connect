class Relation < ApplicationRecord
  acts_as_tenant :account
  validates :name, format: { with: /\A[a-zA-Z ]+\z/,
                             message: " Allows only letters" }
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  has_one :contacts
  has_many :relatives
  has_many :contacts, through: :relatives, dependent: :restrict_with_exception
  scope :for_current_account, -> { where(account: Current.account) }
end
