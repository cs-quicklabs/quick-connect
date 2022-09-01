class Journal < ApplicationRecord
  acts_as_tenant :account
  belongs_to :user
  validates_presence_of :title, :body
  has_many :comments, dependent: :destroy
  has_many :events, as: :eventable, dependent: :destroy
  normalize_attribute :title, :body, :with => :strip
  validates :title,
            :length => { :maximum => 25 }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
