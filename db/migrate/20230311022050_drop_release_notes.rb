class DropReleaseNotes < ActiveRecord::Migration[7.0]
  def change
    drop_table :release_notes
  end
end
