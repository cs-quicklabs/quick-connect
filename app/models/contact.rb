class Contact < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_tenant :account
  scope :for_current_account, -> { where(account: Current.account) }
  belongs_to :user
  belongs_to :account
  validates_presence_of :first_name, :last_name, :phone
  validates_uniqueness_of :phone, scope: :account
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  scope :archived, -> { where(archived: true) }
  scope :available, -> { where(archived: false) }
  validates :phone, :presence => true,
                    :numericality => true,
                    :length => { :minimum => 10, :maximum => 12 }
  validates :email, :allow_blank => true, format: { with: URI::MailTo::EMAIL_REGEXP }
  belongs_to :relation, optional: true
  has_many :tasks, dependent: :destroy
  has_many :relatives, dependent: :destroy
  has_many :relations, through: :relatives, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :gifts, dependent: :destroy
  normalize_attribute :first_name, :last_name, :email, :with => :strip
  has_and_belongs_to_many :labels, dependent: :destroy
  has_many :documents, dependent: :destroy
end
