class SetRelationTableNotNull < ActiveRecord::Migration
  def change
    change_column :user_share_payment_relations, :permission, :integer, null: false 
    change_column :user_share_payment_relations, :share_user_id, :integer, null: false 
    change_column :user_share_payment_relations, :owner_user_id, :integer, null: false 
    change_column :user_share_payment_relations, :payment_hash_key, :string, null: false 
    add_column(:user_share_payment_relations, :created_at, :datetime)
    add_column(:user_share_payment_relations, :updated_at, :datetime)
  end
end
