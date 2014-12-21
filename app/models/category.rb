class Category < ActiveRecord::Base
  self.table_name = "category_table"
  self.inheritance_column = :_type_disabled

  default_scope { order('order_no desc') }

  scope :not_hidden, ->{where("category_table.hidden = 0 and category_table.is_delete = 0")} 
  
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  scope :api_select, -> { where(is_delete: false).select("id,category,type,photo_path,hidden,order_no,hash_key,update_time"
                        ) }
end
