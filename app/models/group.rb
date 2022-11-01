class Group < ApplicationRecord
  validates_uniqueness_of :name, :case_sensitive => false
end
