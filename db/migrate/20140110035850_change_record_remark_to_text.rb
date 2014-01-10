class ChangeRecordRemarkToText < ActiveRecord::Migration
  def change
    change_column :record_table, :remark, :text
  end
end
