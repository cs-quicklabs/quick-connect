class AddBodyToJournal < ActiveRecord::Migration[7.0]
  def change
    add_column :journals, :body, :string, null: false
  end
end
