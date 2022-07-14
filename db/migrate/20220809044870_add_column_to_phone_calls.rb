class AddColumnToPhoneCalls < ActiveRecord::Migration[7.0]
  def change
    add_column :phone_calls, :date, :date, null: false, default: -> { "CURRENT_DATE" }
  end
end
