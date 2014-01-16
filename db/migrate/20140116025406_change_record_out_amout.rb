class ChangeRecordOutAmout < ActiveRecord::Migration
  def change
    change_column :record_table, :out_amount, :decimal, :precision => 16, :scale => 2
  end
end
