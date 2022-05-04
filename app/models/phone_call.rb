class PhoneCall < ApplicationRecord
    belongs_to :user
    validates_presence_of :body
    belongs_to :contact
    end