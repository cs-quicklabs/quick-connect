class Activity < ApplicationRecord
  self.table_name = "activities"
  acts_as_tenant :account
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  scope :for_current_account, -> { where(account: Current.account) }
  belongs_to :group, class_name: "Group", foreign_key: "group_id"
end