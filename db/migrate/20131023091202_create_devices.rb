class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.integer :user_id
      t.string :uuid
      t.datetime :last_sync_time
      t.datetime :sync_start_time
    end
    add_index :devices, :user_id
    add_index :devices, :uuid
  end
end
