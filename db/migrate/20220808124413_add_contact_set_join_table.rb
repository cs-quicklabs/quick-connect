class AddContactSetJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :contacts, :batches do |t|
    end
  end
end
