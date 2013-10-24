class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategory_table do |t|
      
      t.string :id_category
      t.string :subcategory
      t.integer :hidden
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
