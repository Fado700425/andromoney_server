class CreateProjects < ActiveRecord::Migration
  def change
    create_table :project_table do |t|
      t.string :project_name
      t.boolean :hidden
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time

      t.timestamps
    end
    add_index :project_table,:hash_key
  end
end
