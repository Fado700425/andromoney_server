class Payee < ActiveRecord::Base
  self.table_name = "payee_table"
  belongs_to :user
end
