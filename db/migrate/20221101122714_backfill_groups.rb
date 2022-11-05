class BackfillGroups < ActiveRecord::Migration[7.0]
  def change
    binding.irb
    Group.create(id:12, name: "Work", category: "activity" )
  end
end
