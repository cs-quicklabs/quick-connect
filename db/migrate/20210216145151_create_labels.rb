class CreateLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :labels do |t|
      t.string :name
      t.string :color, null: false, default: ""
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
