class ChangeDefaultDateToRatings < ActiveRecord::Migration[7.0]
  def change
    change_column :ratings, :date, :date, null: false, default: -> { "CURRENT_DATE" }
  end
end
