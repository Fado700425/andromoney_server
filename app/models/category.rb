class Category < ActiveRecord::Base
  self.table_name = "category_table"
  self.inheritance_column = :_type_disabled
  
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  scope :api_select, -> { select("id,category,type,photo_path,hidden,order_no,hash_key,update_time"
                        ) }
end
