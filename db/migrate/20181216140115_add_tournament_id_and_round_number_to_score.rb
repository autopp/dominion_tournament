class AddTournamentIdAndRoundNumberToScore < ActiveRecord::Migration[5.2]
  def change
    add_reference :scores, :tournament, foreign_key: true
    add_column :scores, :round_number, :integer, default: 0, null: false
  end
end
