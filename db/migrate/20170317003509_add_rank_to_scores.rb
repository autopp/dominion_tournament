class AddRankToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :rank, :integer
  end
end
