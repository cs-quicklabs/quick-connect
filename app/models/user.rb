class User < ApplicationRecord
  require "securerandom"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :timeoutable, timeout_in: 5.days, invite_for: 2.weeks
  validates_confirmation_of :password
  scope :available, -> { all_users }
  before_create :set_invitation_limit
  scope :for_current_account, -> { where(account: Current.account) }
  enum permission: [:true, :false]
  enum admin: [:false, :true], _prefix: :true
  belongs_to :account, optional: true
  validates :email, uniqueness: true
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
  belongs_to :invited_by, :class_name => "User", optional: true
  has_many :reminders, dependent: :destroy

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    save!
  end

  def set_invitation_limit
    self.invitation_limit = 5
  end
end
