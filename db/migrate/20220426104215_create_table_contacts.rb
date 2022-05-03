class CreateTableContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :email,null: false, default: ""
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :phone, null: false, default: ""
      t.datetime :birthday, null: true, default: ""
      t.string :address, null: true, default: ""
      t.string :about, null: true, default: ""
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true
      t.timestamps
    end
    add_index :contacts, :first_name
  end
end
