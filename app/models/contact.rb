class Contact < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    scope :available, -> { all_contacts }
    scope :for_current_account, -> { where(account: Current.account) }
    belongs_to :user
    belongs_to :account
    validates_presence_of :first_name, :last_name, :email, :phone
    validates_uniqueness_of :phone
    has_many :notes, dependent: :destroy
  end
  