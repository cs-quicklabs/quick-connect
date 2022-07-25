class CreateContactActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :contact_activities do |t|
      t.string :title
      t.string :body
      t.date :date, null: false, default: -> { "CURRENT_DATE" }
      t.references :activity, null: false, foreign_key: true
      t.references :contact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
