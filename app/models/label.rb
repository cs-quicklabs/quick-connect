class Label < ApplicationRecord
    acts_as_tenant :account
    validates_presence_of :name
    validates_uniqueness_to_tenant :name
    scope :for_current_account, -> { where(account: Current.account) }
  end
  