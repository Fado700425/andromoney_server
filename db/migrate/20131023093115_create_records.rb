class CreateRecords < ActiveRecord::Migration
  def change
    create_table :record_table do |t|
      t.string :project_name
      t.float :amount
      t.integer :category_id
      t.integer :subcategory_id
      t.string  :category_hash_key
      t.string  :subcategory_hash_key


      t.datetime :date
      t.boolean :in_payment
      t.boolean :out_payment
      t.text :remark
      t.string :currency_code
      t.float :amount_to_main
      t.integer :period_id
      t.integer :payee_id
      t.integer :project_id
      t.string :hash_key
      t.boolean :is_delete, default: false

      t.float :in_amount
      t.float :out_amount
      t.string :in_currency
      t.string :out_currency
      
      t.integer :user_id

      t.timestamps
    end
    add_index :record_table,:hash_key
    add_index :record_table,:user_id
  end
end
