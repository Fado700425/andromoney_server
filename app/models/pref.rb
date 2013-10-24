class Pref < ActiveRecord::Base
  self.table_name = "pref_table"
  belongs_to :user
end
