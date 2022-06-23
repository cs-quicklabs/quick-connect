class User < ApplicationRecord
  require "securerandom"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, timeout_in: 5.days
  scope :available, -> { all_users }
  scope :for_current_account, -> { where(account: Current.account) }
  enum permission: [:member, :admin]
  belongs_to :account
  validates :email, uniqueness: true
  validates :first_name, format: { with: /\A[a-zA-Z ]+\z/,
                                   message: " Allows only letters" }
  validates :last_name, format: { with: /\A[a-zA-Z ]+\z/,
                                  message: " Allows only letters" }
  validates_presence_of :first_name, :last_name, :email
  has_many :contacts, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :journals
  has_many :release_notes, dependent: :destroy
  has_many :ratings, class_name: "Rating", foreign_key: "user_id"
  has_many :events
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  has_many :tasks, dependent: :destroy
  before_create :add_jti
  has_many :comments

  def add_jti
    self.jti ||= SecureRandom.uuid
  end
end
