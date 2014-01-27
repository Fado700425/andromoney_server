class Payee < ActiveRecord::Base
  self.table_name = "payee_table"
  self.inheritance_column = :_type_disabled
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  belongs_to :user

  default_scope { order('order_no desc') } 
  scope :not_hidden, ->{where("hidden = 0")} 

  scope :api_select, -> { where(is_delete: false).select("id,payee_name,hidden,type,order_no,hash_key,order_no,update_time"
                        ) }
end
