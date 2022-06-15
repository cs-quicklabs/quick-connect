class CreateFieldTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.references :account, null: false, foreign_key: true
      t.string :name, null: false
      t.string :protocol, null: true
      t.string :icon, null: true
      t.boolean :type, null: false, default: false
      t.timestamps
    end
  end
end
