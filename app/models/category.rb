class Category < ActiveRecord::Base
  self.table_name = "category_table"
  
  belongs_to :user
end
