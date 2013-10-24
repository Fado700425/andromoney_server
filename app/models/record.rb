class Record < ActiveRecord::Base
  self.table_name = "record_table"
  belongs_to :user
end
