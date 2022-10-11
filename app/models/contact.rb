class Contact < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_tenant :account
  scope :for_current_account, -> { where(account: Current.account) }
  scope :favorites, -> { where(favorite: true) }
  belongs_to :user
  belongs_to :account
  normalize_attribute :first_name, :last_name, :email, :with => :strip
  validates_presence_of :first_name, :last_name, on: :create
  validates_uniqueness_of :phone, scope: :account, :allow_blank => true, on: :create
  validates_uniqueness_of :email, scope: :account, :allow_blank => true, on: :create
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy
  scope :archived, -> { where(archived: true) }
  scope :untracked, -> { where(track: false) }
  scope :tracked, -> { where(track: true) }
  scope :available, -> { where(archived: false) }
  validate :validates

  def validates
    if email.blank? && phone.blank?
      errors.add(:phone_number_or, "E-mail can't be blank")
    end
  end

  validates :phone, :allow_blank => true, :format => { with: /^[0-9]{10,12}$/, message: "is invalid", :multiline => true }, if: -> { !phone.blank? }, on: :create
  validates :email, :allow_blank => true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }, if: -> { !email.blank? }, on: :create
  scope :favorites, -> { where(favorite: true) }
  belongs_to :relation, optional: true
  has_many :tasks, dependent: :destroy
  has_many :relatives, dependent: :destroy
  has_many :relations, through: :relatives, dependent: :destroy
  has_many :events, class_name: "Event", as: :eventable, dependent: :destroy
  has_many :conversations, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :gifts, dependent: :destroy
  normalize_attribute :first_name, :last_name, :email, :with => :strip
  has_and_belongs_to_many :labels, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :contact_activities, dependent: :destroy
  has_many :contact_events, dependent: :destroy
  has_and_belongs_to_many :batches, dependent: :destroy

  has_many :reminders, dependent: :destroy
  has_one :abouts, class_name: "About", dependent: :destroy
end
