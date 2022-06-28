class AddColumnToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :action_context, :string, null: true
  end
end
