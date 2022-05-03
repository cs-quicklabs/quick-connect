class Account < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: "owner_id", optional: true
    has_many :users, dependent: :destroy
    has_many :contacts, dependent: :destroy
end
