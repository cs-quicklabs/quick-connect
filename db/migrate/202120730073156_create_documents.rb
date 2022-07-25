class CreateDocuments < ActiveRecord::Migration[6.1]
  def change
    create_table :documents do |t|
      t.string :filename
      t.string :link
      t.string :comments
      t.references :user, foreign_key: true
      t.references :contact, foreign_key: true
      t.timestamps
    end
  end
end
