class Payee < ActiveRecord::Base
  self.table_name = "payee_table"
  self.inheritance_column = :_type_disabled
  
  belongs_to :user
end
