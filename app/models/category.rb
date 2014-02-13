class Category < ActiveRecord::Base
  self.table_name = "category_table"
  self.inheritance_column = :_type_disabled

  default_scope { order('order_no desc') }

  scope :not_hidden, ->{where("hidden = 0 and is_delete = 0")} 
  
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  validates_presence_of :category
  scope :api_select, -> { where(is_delete: false).select("id,category,type,photo_path,hidden,order_no,hash_key,update_time"
                        ) }
end
