class Label < ApplicationRecord
  before_save :set_default
  acts_as_tenant :account
  validates :name, format: { with: /\A[a-zA-Z ]+\z/,
                             message: " Allows only letters" }
  validates_uniqueness_to_tenant :name, :case_sensitive => false
  scope :for_current_account, -> { where(account: Current.account) }
  has_and_belongs_to_many :contacts, touch: true

  protected

  def set_default
    self.color = "gray" if self.color.blank?
  end
end
