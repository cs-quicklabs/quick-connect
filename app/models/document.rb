class Document < ApplicationRecord
  belongs_to :user
  validates_presence_of :filename, :link
  belongs_to :contact
  normalize_attribute :filename, :comments, :link, :with => :strip
  validates :filename,
            :length => { :maximum => 25 }
  has_many :events, class_name: "Event", as: :trackable, dependent: :destroy
end
