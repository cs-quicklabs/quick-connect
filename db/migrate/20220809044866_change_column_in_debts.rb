class ChangeColumnInDebts < ActiveRecord::Migration[7.0]
  def change
    change_column :debts, :owed_by, :string, null: true, :default => "user"
  end
end
