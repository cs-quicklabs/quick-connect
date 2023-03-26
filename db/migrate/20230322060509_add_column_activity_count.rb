class AddColumnActivityCount < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :activity_count, :integer, default: 0
  end
end
