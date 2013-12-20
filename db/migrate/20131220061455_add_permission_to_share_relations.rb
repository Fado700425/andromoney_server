class AddPermissionToShareRelations < ActiveRecord::Migration
  def change
    add_column :user_share_payment_relations, :permission, :integer
  end
end
