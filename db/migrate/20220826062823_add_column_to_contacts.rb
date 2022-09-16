class AddColumnToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :track, :boolean, null: false, default: true
    add_column :contacts, :untrack_on, :date, null: true
  end
end
