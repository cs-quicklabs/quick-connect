class CreateConversations < ActiveRecord::Migration[7.0]
  def change
    create_table :conversations do |t|
      t.text :body
      t.references :contact, foreign_key: true
      t.references :user, foreign_key: true
      t.references :field, foreign_key: true
      t.date :date, null: false, default: -> { "CURRENT_DATE" }
      t.timestamps
    end
  end
end
