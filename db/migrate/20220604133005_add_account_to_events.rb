class AddAccountToEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :events, :account, null: false, foreign_key: true
  end
end
