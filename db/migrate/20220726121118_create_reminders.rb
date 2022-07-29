class CreateReminders < ActiveRecord::Migration[7.0]
  def change
    create_table :reminders do |t|
      t.string :title
      t.integer :reminder_type
      t.integer :status
      t.integer :remind_after
      t.date :reminder_date
      t.string :comments
      t.references :user, foreign_key: true
      t.references :contact, foreign_key: true
      t.timestamps
    end
  end
end
