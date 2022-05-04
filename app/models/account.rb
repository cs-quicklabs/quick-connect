class Account < ApplicationRecord
    has_many :users, dependent: :destroy
    has_many :contacts, dependent: :destroy
end
