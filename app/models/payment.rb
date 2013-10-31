class Payment < ActiveRecord::Base
  self.table_name = "payment_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]

  scope :api_select, -> { where(is_delete: false).select("id,kind,payment_name,total,currency_code,rate,out_total,hidden,order_no,hash_key,update_time"
                        ) }
end
