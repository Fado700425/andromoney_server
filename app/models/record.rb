class Record < ActiveRecord::Base
  self.table_name = "record_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]

  scope :api_select, -> { where(is_delete: false).select("id,mount,category,sub_category,date, in_payment,out_payment,remark,currency_code,amount_to_main,period,
                              payee,project,fee,in_amount,out_amount,in_currency,out_currency,hash_key,update_time"
                        ) }
end
