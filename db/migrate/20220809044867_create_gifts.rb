class CreateGifts < ActiveRecord::Migration[7.0]
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :body
      t.string :status, default: "recieved"
      t.references :user, foreign_key: true
      t.references :contact, foreign_key: true
      t.datetime :date
      t.timestamps
    end
  end
end
