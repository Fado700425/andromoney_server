class CreatePayees < ActiveRecord::Migration
  def change
    create_table :payees do |t|
      t.string :payee_name
      t.boolean :hidden
      t.integer :type
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete
      t.integer :user_id

      t.timestamps
    end
    add_index :payees, :hash_key
  end
end
