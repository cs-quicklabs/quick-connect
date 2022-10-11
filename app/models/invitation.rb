class Invitation < ApplicationRecord
  acts_as_tenant :account
  belongs_to :sender, :class_name => "User"
  belongs_to :user, :class_name => "User", optional: true
  normalize_attribute :first_name, :last_name, :email, :with => :strip
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: true
  validates_presence_of :first_name, :last_name
  validate :user_is_not_registered, on: :create
  has_many :events, class_name: "Event", foreign_key: "eventable", dependent: :destroy

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end

  def user_is_not_registered
    errors.add :email, "is already registered" if User.find_by_email(email)
  end
end
