class CreateCategories < ActiveRecord::Migration
  def change
    create_table :category_table do |t|
      t.string :category
      t.integer :type
      t.string :photo_path
      t.integer :hidden
      t.integer :order_no
      t.string :hash_key
      t.integer :user_id
      t.boolean :is_delete, default: false
      t.datetime :update_time

      t.timestamps
    end
    add_index :category_table, :hash_key
    add_index :category_table, :user_id
  end
end
