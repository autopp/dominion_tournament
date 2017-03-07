class AddReferences < ActiveRecord::Migration[5.0]
  def change
    add_reference :players, :tournament, foreign_key: true
    add_reference :rounds, :tournament, foreign_key: true
    add_reference :tables, :round, foreign_key: true
    add_reference :scores, :player, foreign_key: true
    add_reference :scores, :table, foreign_key: true
  end
end
