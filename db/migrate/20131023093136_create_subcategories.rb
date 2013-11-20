class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategory_table do |t|
      
      t.string :id_category
      t.string :subcategory, null: false
      t.integer :hidden, null: false
      t.integer :order_no
      t.string :hash_key, null: false
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time, null: false

      t.timestamps
    end
    add_index :subcategory_table,:hash_key
    add_index :subcategory_table,:user_id
  end
end
