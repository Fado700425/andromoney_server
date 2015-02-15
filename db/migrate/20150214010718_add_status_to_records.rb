class AddStatusToRecords < ActiveRecord::Migration
  def change
  	add_column :record_table, :status, :integer
  end
end
