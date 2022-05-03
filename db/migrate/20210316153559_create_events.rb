class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string :action

      t.timestamps
    end
  end
end
