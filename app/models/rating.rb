class Rating < ApplicationRecord
  acts_as_tenant :account
  belongs_to :user
  enum rating: [:awesome, :normal, :poor]
  validates_presence_of :rating
  validates :user, uniqueness: { scope: :date }
end
