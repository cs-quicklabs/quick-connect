class User < ApplicationRecord
  pay_customer

  # Include default devise modules.
  include Devise::JWT::RevocationStrategies::JTIMatcher
  require "securerandom"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :timeoutable, timeout_in: 5.days, invite_for: 2.weeks
  devise :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null
  validates :jti, presence: true, on: :update

  def generate_jwt
    JWT.encode({ id: id,
                 exp: 2.days.from_now.to_i },
               Rails.application.credentials.secret_key_base, true, { :algorithm => "HS256" })
  end

  normalize_attribute :first_name, :last_name, :email, :with => :strip
  validates_confirmation_of :password, if: :password_confirmation_given?, on: :update

  def password_confirmation_given?
    password_confirmation ? true : false
  end

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
  
  def upcoming_tasks 
    self.tasks.joins(:contact).where("contacts.archived=?", false).order(created_at: :desc).limit(10)
  end

  def upcoming_reminders
    reminders = self.reminders.joins("INNER JOIN contacts ON contacts.id = reminders.contact_id").where("contacts.archived=?", false).to_a
    upcoming_reminders = []
    reminders.each do |reminder|
      upcoming_reminders += reminder.upcoming
    end
    upcoming_reminders.sort_by { |r| r.third[:reminder] }
  end
end
