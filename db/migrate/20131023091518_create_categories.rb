class CreateCategories < ActiveRecord::Migration
  def change
    create_table :category_table do |t|
      t.string :category, null: false
      t.integer :type, null: false
      t.string :photo_path, null: false
      t.integer :hidden, null: false
      t.integer :order_no
      t.string :hash_key, null: false
      t.integer :user_id
      t.boolean :is_delete, default: false
      t.datetime :update_time, null: false

      t.timestamps
    end
    add_index :category_table, :hash_key
    add_index :category_table, :user_id
  end
end
