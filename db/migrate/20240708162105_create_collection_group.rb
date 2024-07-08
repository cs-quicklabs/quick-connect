class CreateCollectionGroup < ActiveRecord::Migration[7.0]
  def change
    create_join_table :collections, :batches do |t|
      t.timestamps
    end
  end
end
