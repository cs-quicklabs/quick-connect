class BackfillInvitationLimit < ActiveRecord::Migration[7.0]
  def change
    users = User.all
    users.each do |user|
      user.invitation_limit = 10
    end
  end
end
