class Payment < ActiveRecord::Base
  self.table_name = "payment_table"
  belongs_to :user
end
