class UserSharePaymentRelation < ActiveRecord::Base
  belongs_to :owner, foreign_key: :owner_user_id, class_name: "User"
  belongs_to :share, foreign_key: :share_user_id, class_name: "User"

  def payment
    Payment.find_by(hash_key: payment_hash_key)
  end
end
