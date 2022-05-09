class AddRelationIdToContact < ActiveRecord::Migration[7.0]
  def up
    change_table :contacts do |t|
      t.references :relation, foreign_key: true
        end
  end
end
