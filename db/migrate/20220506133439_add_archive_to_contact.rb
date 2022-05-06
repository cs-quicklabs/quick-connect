class AddArchiveToContact < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :archived, :boolean, default: false
    add_column :contacts, :archived_on, :date
  end
end
