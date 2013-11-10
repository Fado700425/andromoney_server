class CreatePayees < ActiveRecord::Migration
  def change
    create_table :payee_table do |t|
      t.string :payee_name
      t.integer :hidden
      t.integer :type
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time

      t.timestamps
    end
    add_index :payee_table, :hash_key
    add_index :payee_table, :user_id
  end
end
