class ChangeContactsEmailToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :contacts, :email, :string, null: true, default: ""
  end
end
