class Project < ActiveRecord::Base
  self.table_name = "project_table"
  belongs_to :user
end
