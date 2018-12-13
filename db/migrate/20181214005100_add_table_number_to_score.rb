class AddTableNumberToScore < ActiveRecord::Migration[5.2]
  def change
    add_column :scores, :table_number, :integer, default: 0, null: false
  end
end
