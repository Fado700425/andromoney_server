class Payee < ActiveRecord::Base
  self.table_name = "payee_table"
  self.inheritance_column = :_type_disabled
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  belongs_to :user

  default_scope { where("hidden = 0").order('order_no desc') } 

  scope :api_select, -> { where(is_delete: false).select("id,payee_name,hidden,type,order_no,hash_key,order_no,update_time"
                        ) }
end
