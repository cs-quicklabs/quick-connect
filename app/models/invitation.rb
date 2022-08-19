class Invitation < ApplicationRecord
  acts_as_tenant :account
  belongs_to :user, :class_name => "User"

  validates_presence_of :email
  validate :invite_is_not_registered
  #validate :user_has_invitations, :if => :user

  before_create :generate_token
  #before_create :decrement_user_count, :if => :user

  private

  def invite_is_not_registered
    errors.add :email, "is already registered" if User.find_by_email(email)
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand].join)
  end
end
