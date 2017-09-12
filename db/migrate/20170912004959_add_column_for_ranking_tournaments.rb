class AddColumnForRankingTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :total_vp_used, :boolean, default: true, null: false
    add_column :tournaments, :rank_histroy_used, :boolean, default: true, null: false
  end
end
