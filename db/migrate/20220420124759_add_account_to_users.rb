class AddAccountToUsers < ActiveRecord::Migration[7.0]
  def up
    change_table :users do |t|
t.references :account, foreign_key: true
  end
end
end
