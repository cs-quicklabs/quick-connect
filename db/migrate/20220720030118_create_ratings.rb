class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.integer :rating, null: false, default: 1
      t.references :user, foreign_key: true
      t.date :date, null: false, default: Date.today
      t.timestamps
    end
  end
end
