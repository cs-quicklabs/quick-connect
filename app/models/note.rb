class Note < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
  validates :title,
            :length => { :maximum => 25 }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
