class BackfillGroups < ActiveRecord::Migration[7.0]
  def change
    Group.insert_all([{ name: "Work", category: "activity" }])
  end
end
