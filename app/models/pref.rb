class Pref < ActiveRecord::Base
  self.table_name = "pref_table"
  belongs_to :user
  validates_uniqueness_of :key, scope: [ :user_id ]
end
