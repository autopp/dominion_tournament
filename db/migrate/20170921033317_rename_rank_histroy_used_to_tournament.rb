class RenameRankHistroyUsedToTournament < ActiveRecord::Migration[5.0]
  def change
    rename_column :tournaments, :rank_histroy_used, :rank_history_used
  end
end
