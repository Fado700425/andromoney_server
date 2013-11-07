class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payment_table do |t|
      t.integer :kind
      t.string :payment_name
      t.decimal :total, :precision => 16, :scale => 2
      t.string :currency_code
      t.decimal :rate, :precision => 16, :scale => 6
      t.integer :out_total
      t.integer :hidden
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time

      t.timestamps
    end
    add_index :payment_table,:hash_key
  end
end
