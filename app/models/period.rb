class Period < ActiveRecord::Base
  self.table_name = "period_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  scope :api_select, -> { select("id,start_date,end_date,update_date,period_type,period_num,order_no,hash_key,update_time"
                        ) }
end
