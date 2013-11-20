class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payment_table do |t|
      t.integer :kind, null: false
      t.string :payment_name, null: false
      t.decimal :total, :precision => 16, :scale => 2, null: false
      t.string :currency_code
      t.decimal :rate, :precision => 16, :scale => 6
      t.integer :out_total
      t.integer :hidden, null: false
      t.integer :order_no
      t.string :hash_key, null: false
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time, null: false

      t.timestamps
    end
    add_index :payment_table,:hash_key
    add_index :payment_table,:user_id
    add_index :payment_table,:currency_code
  end
end
