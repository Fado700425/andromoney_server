class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category
      t.integer :type
      t.string :photo
      t.boolean :hidden
      t.integer :order_no
      t.string :hash_key
      t.integer :user_id
      t.boolean :is_delete

      t.timestamp
    end
    add_index :categories, :hash_key
  end
end
