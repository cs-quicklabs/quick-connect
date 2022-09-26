class AddColumnIsAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :integer, null: false, default: false
  end
end
