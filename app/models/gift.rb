class Gift < ApplicationRecord
  belongs_to :user
  validates_presence_of :name, :date, :body, :status
  belongs_to :contact
end
