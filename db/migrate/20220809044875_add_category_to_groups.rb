class AddCategoryToGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :category, :string, null: false, default: "activity"
  end
end
