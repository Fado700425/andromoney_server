class CreateUserSharePaymentRelations < ActiveRecord::Migration
  def change
    create_table :user_share_payment_relations do |t|
      t.integer :share_user_id
      t.integer :owner_user_id
      t.string  :payment_hash_key
      t.boolean :is_approved, default: false
      t.string  :token
    end
    add_index :user_share_payment_relations,:share_user_id
    add_index :user_share_payment_relations,:owner_user_id
    add_index :user_share_payment_relations,:payment_hash_key
    add_index :user_share_payment_relations,:is_approved
    add_index :user_share_payment_relations,:token
  end
end
