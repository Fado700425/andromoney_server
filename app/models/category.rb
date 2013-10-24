class Category < ActiveRecord::Base
  self.table_name = "category_table"
  self.inheritance_column = :_type_disabled
  
  belongs_to :user
end
