class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.string :link
      t.string :link_type
      t.references :user, foreign_key: true
      t.references :contact, foreign_key: true
    end
  end
end
