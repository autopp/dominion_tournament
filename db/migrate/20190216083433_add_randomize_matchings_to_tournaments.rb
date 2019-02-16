class AddRandomizeMatchingsToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :randomize_matchings, :boolean, default: false, null: false
  end
end
