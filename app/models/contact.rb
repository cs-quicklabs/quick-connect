class Contact < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :relation_name
  require "activerecord-import"
  acts_as_tenant :account
  enum :touch_back_after, ["30_days", "60_days", "90_days", "100_days", "do_not_track"]
  TOUCH_BACK_AFTER_OPTIONS = [{ id: "30_days", name: "30 days" }, { id: "60_days", name: "60 days" }, { id: "90_days", name: "90 days" }, { id: "100_days", name: "100 days" }, { id: "do_not_track", name: "Do not track" }]
  scope :for_current_account, -> { where(account: Current.account) }
  scope :favorites, -> { where(favorite: true) }
  scope :thirty_days, -> { where(touch_back_after: 0) }
  scope :sixty_days, -> { where(touch_back_after: 1) }
  scope :ninety_days, -> { where(touch_back_after: 2) }
  scope :over_100_days, -> { where(touch_back_after: 3) }
  belongs_to :user
  belongs_to :account
  normalize_attribute :first_name, :last_name, :email, :with => :strip
  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :phone, scope: :account, :allow_blank => true, if: -> { phone.present? }
  validates_uniqueness_of :email, scope: :account, :allow_blank => true, if: -> { email.present? }
  has_many :notes, dependent: :destroy
  has_many :phone_calls, dependent: :destroy

  scope :archived, -> { where(archived: true) }
  scope :untracked, -> { where(touch_back_after: "do_not_track") }
  scope :tracked, -> { where.not(touch_back_after: "do_not_track") }
  scope :available, -> { where(archived: false) }
  scope :popular, -> { order(activity_count: :desc) }
  scope :favorites, -> { select { |c| c.favorite? } }
  scope :recent, -> { order(created_at: :desc) }

  validate :validates

  def validates
    if email.blank? && phone.blank?
      errors.add(:phone_number_or, "E-mail can't be blank")
    end
  end

  validates :phone, :allow_blank => true, :format => { with: /^[0-9]{10,12}$/, message: "is invalid", :multiline => true }, if: -> { !phone.blank? }
  validates :email, :allow_blank => true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }, if: -> { !email.blank? }
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
  has_many :links, dependent: :destroy

  has_many :reminders, dependent: :destroy
  has_one :abouts, class_name: "About", dependent: :destroy

  def self.to_csv
    attributes = %w{id name email phone}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |contact|
        csv << attributes.map { |attr| contact.send(attr) }
      end
    end
  end
  def self.save_all(contacts)
    i = 0
    contacts.each do |contact|
      if contact.save
        About.create(user: contact.user, contact: contact)
        i += 1
      end
    end
    return i
  end

  def self.sample
    attributes = %w{id name email phone}

    CSV.generate(headers: true) do |csv|
      csv << attributes
    end
  end

  def self.import(file, current_user)
    contacts = []
    CSV.foreach(file.path, headers: true) do |row|
      if !row[1].nil?
        contact_hash = Contact.new
        contact_hash.first_name = row[1].split(" ")[0].downcase
        contact_hash.last_name = row[1].split(" ")[1] ? row[1].split(" ")[1].downcase : ""
        contact_hash.email = row[2]
        contact_hash.phone = row[3]
        contact_hash.user_id = current_user.id
        contacts += [contact_hash]
      end
    end
    return contacts
  end

  def last_event
    self.events.sanitize.first
  end

  def name
    "#{first_name} #{last_name}".titleize
  end
end
