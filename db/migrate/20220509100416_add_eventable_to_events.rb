class AddEventableToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :eventable_id, :integer
    add_column :events, :eventable_type, :string
  end
end
