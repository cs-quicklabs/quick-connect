class AddTouchedAtToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :touched_at, :date, default: nil
  end
end
