class DropTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :tables
    remove_column :rounds, :table_id, :integer
    remove_column :scores, :table_id, :integer
  end
end
