class UpdateColumnsInContacts < ActiveRecord::Migration[7.0]
  def change
    remove_column :contacts, :track, :boolean
    rename_column :contacts, :untrack_on, :followup_after_changed_on
  end
end
