class Subcategory < ActiveRecord::Base
  self.table_name = "subcategory_table"
  belongs_to :user
  default_scope { order('order_no desc') } 
  scope :not_hidden, ->{where("hidden = 0 and is_delete = 0")} 
  
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  validates_presence_of :subcategory
  scope :api_select, -> { where(is_delete: false).select("id,id_category,subcategory,hidden,order_no,hash_key,update_time"
                        ) }
end
