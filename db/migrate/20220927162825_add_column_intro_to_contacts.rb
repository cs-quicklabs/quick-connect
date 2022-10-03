class AddColumnIntroToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :intro, :string, null: true, default: nil
  end
end
