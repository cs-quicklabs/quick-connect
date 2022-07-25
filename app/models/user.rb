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
  validates :email, uniqueness: true, confirmation: true
  validates_presence_of :first_name, :last_name, :email
  has_many :contacts, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  has_many :journals, dependent: :destroy
  has_many :release_notes, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  has_many :tasks, dependent: :destroy
  before_create :add_jti
  has_many :comments
  has_many :debts, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :gifts, dependent: :destroy
  normalize_attribute :first_name, :last_name, :email, :with => :strip

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    save!
  end
end
