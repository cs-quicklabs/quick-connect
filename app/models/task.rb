class Task < ApplicationRecord
    belongs_to :user
    validates_presence_of :title, :due_date
    belongs_to :contact
    end