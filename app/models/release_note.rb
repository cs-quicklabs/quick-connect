class ReleaseNote < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :body
  has_many :events, as: :eventable, dependent: :destroy
  has_rich_text :body
end
