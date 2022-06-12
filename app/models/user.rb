class User < ApplicationRecord
  require "securerandom"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :timeoutable, timeout_in: 5.days
  scope :available, -> { all_users }
  scope :for_current_account, -> { where(account: Current.account) }
  belongs_to :account
  validates :email, uniqueness: true
  validates_presence_of :first_name, :last_name, :email
  has_many :contacts, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :journals

  has_many :ratings, class_name: "Rating", foreign_key: "user_id"


  before_create :add_jti

  def add_jti
    self.jti ||= SecureRandom.uuid
  end
end
