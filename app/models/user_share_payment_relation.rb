class UserSharePaymentRelation < ActiveRecord::Base

  READ = 0
  WRITE = 1

  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  belongs_to :share, foreign_key: :share_user_id, class_name: "User"
  # belongs_to :payment, foreign_key: :payment_hash_key, class_name: "Payment", primary_key: :hash_key

  validates_uniqueness_of :payment_hash_key, scope: [ :owner_user_id, :share_user_id ]
  validates_presence_of :owner_user_id, :share_user_id, :permission, :payment_hash_key

  def payment
    Payment.find_by(hash_key: payment_hash_key, user_id: owner_user_id)
  end
end
