class BackfillContactsTouchDate < ActiveRecord::Migration[7.0]
  def change
    ActsAsTenant.without_tenant do
      Contact.all.each do |contact|
        last_activity = contact.events.follow_up.order(created_at: :desc).first
        contact.touched_at = last_activity.created_at if last_activity.present?
        contact.save!
      end
    end
  end
end
