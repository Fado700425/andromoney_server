class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :period_table do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :update_date
      t.integer :period_type
      t.integer :period_num
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete
      t.integer :user_id
      t.datetime :update_time

      t.timestamps
    end
    add_index :period_table,:hash_key
  end
end
