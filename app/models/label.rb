class Label < ApplicationRecord
  before_save :set_default
  acts_as_tenant :account
  validates_presence_of :name, :case_sensitive => false
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  scope :for_current_account, -> { where(account: Current.account) }
  has_and_belongs_to_many :contacts, touch: true
  normalize_attribute :name, :with => :strip

  protected

  def set_default
    self.color = "gray" if self.color.blank?
  end
end
