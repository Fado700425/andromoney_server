class AddFieldsToPayments < ActiveRecord::Migration
  def change
  	add_column :payment_table, :pay_date, :date
  	add_column :payment_table, :bill_date, :date
  	add_column :payment_table, :remark, :string
  	add_column :payment_table, :pay_payment, :string
  	add_column :payment_table, :alert, :integer
  end
end
