class Period < ActiveRecord::Base
  self.table_name = "period_table"
  belongs_to :user
end
