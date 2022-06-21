class Contact < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  scope :available, -> { all_contacts }
  scope :for_current_account, -> { where(account: Current.account) }
  belongs_to :user
  belongs_to :account
  validates_presence_of :first_name, :last_name, :email, :phone
  validates_uniqueness_of :phone
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
  scope :available, -> { where(archived: false) }
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/,
                                   message: " allows only letters" }
  validates :last_name, format: { with: /\A[a-zA-Z]+\z/,
                                  message: " allows only letters" }
  validates :phone, :presence => true,
                    :numericality => true,
                    :length => { :minimum => 10, :maximum => 12 }
  validates :email, :presence => true, format: { with: URI::MailTo::EMAIL_REGEXP }
  belongs_to :relation, optional: true
  has_many :tasks, dependent: :destroy
  has_many :relatives, dependent: :destroy
  has_many :relations, through: :relatives
  has_many :events, as: :eventable, dependent: :destroy
  has_many :conversations, dependent: :destroy

  has_and_belongs_to_many :labels, dependent: :destroy
end
