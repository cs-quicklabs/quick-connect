class AddIndexToBatchesContacts < ActiveRecord::Migration[7.0]
  def change
    add_index :batches_contacts, [:contact_id, :batch_id], unique: true
  end
end
