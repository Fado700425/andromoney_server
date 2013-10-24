class Subcategory < ActiveRecord::Base
  self.table_name = "subcategory_table"
  belongs_to :user
end
