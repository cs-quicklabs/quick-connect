class CreateContactLabelsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :contacts, :labels
  end
end
