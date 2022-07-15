class AddColumnStatusToPhoneCalls < ActiveRecord::Migration[7.0]
  def change
    add_column :phone_calls, :status, :string, null: false, default: "contact"
  end
end
