class AddFinishedCountToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :finished_count, :integer, default: 0, null: false
  end
end
