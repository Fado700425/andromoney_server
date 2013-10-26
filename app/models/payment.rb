class Payment < ActiveRecord::Base
  self.table_name = "payment_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
end
