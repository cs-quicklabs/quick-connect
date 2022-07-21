class Gift < ApplicationRecord
  belongs_to :user
  validates_presence_of :name, :date, :body, :status
  belongs_to :contact
  normalize_attribute :name, :body, :with => :strip
  validates :name,
            :length => { :maximum => 25 }
end
