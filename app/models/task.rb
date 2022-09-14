class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
  validates :title,
            :length => { :maximum => 25 }
end
