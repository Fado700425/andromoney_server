class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategory_table do |t|
      t.integer :category_id
      t.string :subcategory
      t.boolean :hidden
      t.integer :order_no
      t.string :hash_key
      t.string :category_hash_key
      t.boolean :is_delete
      t.integer :user_id

      t.timestamps
    end
  end
end
