class AddProAndExpireDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_pro, :boolean, default: false
    add_column :users, :expire_date, :datetime
  end
end
