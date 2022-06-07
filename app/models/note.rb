class Note < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  belongs_to :contact
end
