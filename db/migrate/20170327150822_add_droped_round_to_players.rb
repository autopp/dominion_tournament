class AddDropedRoundToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :droped_round, :integer
  end
end
