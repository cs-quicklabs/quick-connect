class ChangeColumnPhoneToNullabel < ActiveRecord::Migration[7.0]
  def change
    change_column :contacts, :phone, :string, null: true, default: ""
  end
end
