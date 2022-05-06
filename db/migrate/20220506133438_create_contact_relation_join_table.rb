class CreateContactRelationJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :contacts, :relations
  end
end
