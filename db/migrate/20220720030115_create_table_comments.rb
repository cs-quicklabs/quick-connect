class CreateTableComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :title
      t.references :user, null: false, foreign_key: true
      t.references :journal, null: false, foreign_key: true
      t.timestamps
    end
  end
end
