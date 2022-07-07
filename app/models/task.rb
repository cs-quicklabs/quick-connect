class Task < ApplicationRecord
  belongs_to :user
  validates_presence_of :title, :due_date
  belongs_to :contact
  normalize_attribute :title, :body, :with => :strip
  after_destroy_commit { broadcast_remove_to(Task) }
end
