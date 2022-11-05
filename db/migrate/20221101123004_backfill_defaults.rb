class BackfillDefaults < ActiveRecord::Migration[7.0]
  def change
    Account.find_each do |account|
      groups = Group.all.uniq.to_a
      if !account.owner_id.nil? && !account.owner.nil?
        ActsAsTenant.with_tenant(account) do
          Activity.insert_all([{ name: "Online meeting", group_id: groups.last.id, default: "TRUE" }, { name: "Meeting in Office ", group_id: groups.values_at(11).first.id, default: "TRUE" }, { name: "Met in Conference", group_id: groups.values_at(11).first.id, default: "TRUE" }])
        end
      end
    end
  end
end
