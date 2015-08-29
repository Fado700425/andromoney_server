class AddStatusToEvenaddColumnsToRecordTablets < ActiveRecord::Migration
  def change
  	add_column :record_table, :receipt_num, :string, :limit => 11
    add_column :record_table, :location_long, :float, :limit => 25
    add_column :record_table, :location_latitude, :float, :limit => 25
    add_column :record_table, :quantity, :integer
  end
end
