class CreateContactRelativesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :contacts, :relatives
  end
end
