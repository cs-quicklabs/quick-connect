class BatchesCollection < ApplicationRecord
  belongs_to :batch, class_name: "Batch", foreign_key: "batch_id"
  belongs_to :collection, class_name: "Collection", foreign_key: "collection_id"
end
