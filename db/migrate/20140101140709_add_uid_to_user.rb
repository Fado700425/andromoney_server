class AddUidToUser < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_index :users, :uid

    add_column :users, :provider, :string
    add_column :users, :refresh_token, :string
    add_column :users, :access_token, :string
    add_column :users, :expires, :timestamp
  end
end
