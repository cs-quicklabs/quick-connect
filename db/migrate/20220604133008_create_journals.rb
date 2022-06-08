class CreateJournals < ActiveRecord::Migration[7.0]
  def change
    create_table :journals do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
