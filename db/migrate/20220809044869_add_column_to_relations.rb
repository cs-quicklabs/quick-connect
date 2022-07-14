class AddColumnToRelations < ActiveRecord::Migration[7.0]
  def change
    add_column :relations, :default, :boolean, null: false, default: false
    add_column :fields, :default, :boolean, null: false, default: false
  end
end
