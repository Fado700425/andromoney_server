class Subcategory < ActiveRecord::Base
  self.table_name = "subcategory_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
end
