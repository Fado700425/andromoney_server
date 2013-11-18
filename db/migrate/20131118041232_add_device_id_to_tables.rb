class AddDeviceIdToTables < ActiveRecord::Migration
  def change
    add_column :category_table, :device_uuid, :string
    add_column :currency_table, :device_uuid, :string
    add_column :payee_table, :device_uuid, :string
    add_column :payment_table, :device_uuid, :string
    add_column :period_table, :device_uuid, :string
    add_column :project_table, :device_uuid, :string
    add_column :record_table, :device_uuid, :string
    add_column :subcategory_table, :device_uuid, :string
    add_column :pref_table, :device_uuid, :string
    
    add_index :category_table, :device_uuid
    add_index :currency_table, :device_uuid
    add_index :payee_table, :device_uuid
    add_index :payment_table, :device_uuid
    add_index :period_table, :device_uuid
    add_index :project_table, :device_uuid
    add_index :record_table, :device_uuid
    add_index :subcategory_table, :device_uuid
    add_index :pref_table, :device_uuid

  end
end
