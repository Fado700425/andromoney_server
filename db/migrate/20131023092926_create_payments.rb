class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payment_table do |t|
      t.integer :kind
      t.string :payment_name
      t.decimal :total
      t.string :currency_code
      t.decimal :rate
      t.integer :out_total
      t.integer :hidden
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete
      t.integer :user_id
      t.datetime :update_time

      t.timestamps
    end
    add_index :payment_table,:hash_key
  end
end
