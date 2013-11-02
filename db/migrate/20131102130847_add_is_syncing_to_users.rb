class AddIsSyncingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_syncing, :boolean, default: false
    add_column :devices, :is_syncing, :boolean, default: false
  end
end
