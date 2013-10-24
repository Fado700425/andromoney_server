class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :kind
      t.string :payment_name
      t.float :total
      t.string :currency_code
      t.float :rate
      t.boolean :hidden
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete
      t.integer :user_id

      t.timestamps
    end
    add_index :payments,:hash_key
  end
end
