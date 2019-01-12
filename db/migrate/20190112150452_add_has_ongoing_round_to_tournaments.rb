class AddHasOngoingRoundToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :has_ongoing_round, :boolean, default: false, null: false
  end
end
