class Currency < ActiveRecord::Base
  self.table_name = "currency_table"
  
  belongs_to :user
end
