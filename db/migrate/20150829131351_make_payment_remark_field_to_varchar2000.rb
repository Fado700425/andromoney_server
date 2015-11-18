class MakePaymentRemarkFieldToVarchar2000 < ActiveRecord::Migration
  def change
    change_column :payment_table, :remark, :string, :limit => 2000
  end
end
