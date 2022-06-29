class CreateDebts < ActiveRecord::Migration[7.0]
  def change
    create_table :debts do |t|
      t.string :title
      t.string :amount
      t.string :owed_by, default: "contact"
      t.references :user, foreign_key: true
      t.references :contact, foreign_key: true
      t.datetime :due_date

      t.timestamps
    end
  end
end
