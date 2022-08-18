class CreateAbouts < ActiveRecord::Migration[7.0]
  def change
    create_table :abouts do |t|
      t.string :address, default: ""
      t.string :breif, default: ""
      t.string :met, default: ""
      t.string :habit, default: ""
      t.string :work, default: ""
      t.string :other, default: ""
      t.references :contact, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
