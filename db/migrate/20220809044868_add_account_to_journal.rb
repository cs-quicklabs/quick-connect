class AddAccountToJournal < ActiveRecord::Migration[7.0]
  def change
    add_column :journals, :account_id, :integer, foreign_key: { to_table: :accounts }
    add_column :ratings, :account_id, :integer, foreign_key: { to_table: :accounts }
  end
end
