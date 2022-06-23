class Label < ApplicationRecord
  acts_as_tenant :account
  validates :name, format: { with: /\A[a-zA-Z ]+\z/,
                             message: " allows only letters" }
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  scope :for_current_account, -> { where(account: Current.account) }
  has_and_belongs_to_many :contacts, touch: true
end
