class AddColumnFirstContactToRelatives < ActiveRecord::Migration[7.0]
  def change
    add_column :relatives, :first_contact_id, :integer, foreign_key: { to_table: :contacts }
    add_column :relatives, :relation_id, :integer, foreign_key: { to_table: :relations }
    add_column :relatives, :contact_id, :integer, foreign_key: { to_table: :contacts }
  end
end
