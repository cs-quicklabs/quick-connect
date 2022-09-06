class AddColumnTo < ActiveRecord::Migration[7.0]
  def change
    add_column :invitations, :sender_id, :integer, foreign_key: { to_table: :users }
  end
end
