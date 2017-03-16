class AddTpToScores < ActiveRecord::Migration[5.0]
  def change
    add_column :scores, :tp_numerator, :integer
    add_column :scores, :tp_denominator, :integer
  end
end
