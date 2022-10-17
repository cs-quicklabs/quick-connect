class Contact < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  require "activerecord-import"
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
  def self.to_csv
    attributes = %w{id name email phone relation favorite intro}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
  def self.import(file, current_user)
    i = 0
    errors = []
    CSV.foreach(file.path, headers: true) do |col|
      contact_hash = Contact.new
      contact_hash.first_name = col[1].split(" ")[0]
      contact_hash.last_name = col[1].split(" ")[1]
      contact_hash.email = col[2]
      contact_hash.phone ||= col[3]
      contact_hash.user_id = current_user.id
      contact_hash.intro = col[4]
      @result = contact_hash.save
      if @result
        i += 1
      elsif contact_hash.errors.errors.empty?
        errors = ["file was empty"]
      else
        errors += [contact_hash.errors]
      end
    end
    return i, errors
  end

  def name
    "#{first_name} #{last_name}"
  end
end
