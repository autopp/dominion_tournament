class AddNumberToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :tables, :number, :integer, default: 1, null: false
  end
end
