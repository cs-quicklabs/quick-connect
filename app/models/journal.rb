class Journal < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  has_many :comments, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
end
