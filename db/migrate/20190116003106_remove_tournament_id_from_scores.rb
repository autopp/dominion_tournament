class RemoveTournamentIdFromScores < ActiveRecord::Migration[5.2]
  def change
    remove_column :scores, :tournament_id, :reference
  end
end
