class AddColumnToActivitiesEventss < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :default, :boolean, null: false, default: false
    add_column :life_events, :default, :boolean, null: false, default: false
  end
end
