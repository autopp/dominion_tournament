class AddNumberToRounds < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :number, :integer, default: 1, null: false
  end
end
