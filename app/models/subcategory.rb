class Subcategory < ActiveRecord::Base
  self.table_name = "subcategory_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]

  scope :api_select, -> { where(is_delete: false).select("id,id_category,subcategory,hidden,order_no,hash_key,update_time"
                        ) }
end
