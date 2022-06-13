class AddPublishedToReleaseNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :release_notes, :published, :boolean, default: false
  end
end
