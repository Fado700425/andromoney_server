class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :update_date
      t.integer :peroid_type
      t.integer :preriod_num
      t.integer :order_no
      t.string :hash_key
      t.boolean :is_delete
      t.integer :user_id

      t.timestamp
    end
    add_index :periods,:hash_key
  end
end
