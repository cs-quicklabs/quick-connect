class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :body
      t.references :contact, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
