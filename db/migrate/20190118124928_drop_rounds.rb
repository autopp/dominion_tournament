class DropRounds < ActiveRecord::Migration[5.2]
  def change
    drop_table :rounds
  end
end
