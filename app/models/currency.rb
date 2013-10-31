class Currency < ActiveRecord::Base
  self.table_name = "currency_table"
  validates_uniqueness_of :currency_code, scope: [ :user_id ]
  belongs_to :user
  scope :api_select, -> { where(is_delete: false).select("id,currency_code,rate,currency_remark,sequence_status,flag_path,order_no,update_time"
                        ) }
end
