class ChangeLabelsNameDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :labels, :color, :string, null: false, :default => "gray"
  end
end
