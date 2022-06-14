class BackfillPermissionAdminToUser < ActiveRecord::Migration[7.0]
  def change
    User.where(email: :"aashishdhawan@crownstack.com").update(permission: :admin)
  end
end
