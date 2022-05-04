class CreateCalls < ActiveRecord::Migration[7.0]
  def change
    create_table :calls do |t|
      t.text :body
      t.references :contact, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
