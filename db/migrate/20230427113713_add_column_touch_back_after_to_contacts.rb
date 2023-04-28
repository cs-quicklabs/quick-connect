class AddColumnTouchBackAfterToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :touch_back_after, :integer, default: 0
  end
end
