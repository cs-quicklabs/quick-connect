class CreateInvitations < ActiveRecord::Migration[7.0]
  def change
    create_table :invitations do |t|
      t.references :user, foreign_key: true
      t.references :account, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :token
      t.datetime :sent_at
      t.timestamps
    end
  end
end
