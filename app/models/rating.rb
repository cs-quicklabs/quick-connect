class Rating < ApplicationRecord
  belongs_to :user
  enum rating: [:awesome, :normal, :poor]
  validates_presence_of :rating
  validates_uniqueness_of :user_id, scope: :date
end
