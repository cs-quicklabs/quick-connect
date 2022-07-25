class AddFavoriteToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :favorite, :boolean, null: false, default: false
  end
end
