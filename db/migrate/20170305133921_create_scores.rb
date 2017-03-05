class CreateScores < ActiveRecord::Migration[5.0]
  def change
    create_table :scores do |t|
      t.integer :vp_numerator
      t.integer :vp_denominator
      t.boolean :has_extra_turn, default: false

      t.timestamps
    end
  end
end
