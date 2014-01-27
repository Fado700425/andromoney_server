class Project < ActiveRecord::Base
  self.table_name = "project_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]

  default_scope { order('order_no desc') } 
  scope :not_hidden, ->{where("hidden = 0")} 

  scope :api_select, -> { where(is_delete: false).select("id,project_name,hidden,order_no,hash_key,update_time"
                        ) }
end
