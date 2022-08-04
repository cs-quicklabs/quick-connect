class Group < ApplicationRecord
  has_many :life_events, -> { order(:name => :asc) }
end
