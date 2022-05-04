class Contact < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    acts_as_tenant :account
    scope :available, -> { all_contacts }
    scope :for_current_account, -> { where(account: Current.account) }
    belongs_to :user
    belongs_to :account
    validates_presence_of :first_name, :last_name, :email
    validates_uniqueness_of :phone
    validates :phone,   :presence => true,
    :numericality => true,
    :length => { :minimum => 10, :maximum => 15 }
    has_many :notes, dependent: :destroy
  end
  