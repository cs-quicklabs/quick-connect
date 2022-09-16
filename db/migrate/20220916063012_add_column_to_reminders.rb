class AddColumnToReminders < ActiveRecord::Migration[7.0]
  def change
    add_reference :reminders, :account, null: false, foreign_key: true
  end
end
