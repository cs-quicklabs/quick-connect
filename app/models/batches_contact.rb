class BatchesContact < ApplicationRecord
  belongs_to :batch, class_name: "Batch", foreign_key: "batch_id"
  belongs_to :contact, class_name: "Contact", foreign_key: "contact_id"
  validates :batch, uniqueness: { scope: :contact }
end
