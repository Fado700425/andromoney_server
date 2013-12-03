class UserSharePaymentRelation < ActiveRecord::Base
  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  belongs_to :share, foreign_key: :share_user_id, class_name: "User"
  belongs_to :payment, foreign_key: :payment_hash_key, class_name: "Payment", primary_key: :hash_key

  validates_uniqueness_of :payment_hash_key, scope: [ :owner_user_id, :share_user_id ]
end
