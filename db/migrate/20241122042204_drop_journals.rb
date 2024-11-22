class DropJournals < ActiveRecord::Migration[7.0]
  def change
    drop_table :comments
    drop_table :ratings
    drop_table :journals
  end
end
