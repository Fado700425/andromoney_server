class CreateProjects < ActiveRecord::Migration
  def change
    create_table :project_table do |t|
      t.string :project_name, null: false
      t.boolean :hidden, null: false
      t.integer :order_no
      t.string :hash_key, null: false
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time, null: false

      t.timestamps
    end
    add_index :project_table,:hash_key
    add_index :project_table,:user_id
  end
end
