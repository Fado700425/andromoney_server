class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :period_table do |t|
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.datetime :update_date
      t.integer :period_type, null: false
      t.integer :period_num, null: false
      t.integer :order_no
      t.string :hash_key, null: false
      t.boolean :is_delete, default: false
      t.integer :user_id
      t.datetime :update_time, null: false

      t.timestamps
    end
    add_index :period_table,:hash_key
    add_index :period_table,:user_id
  end
end
