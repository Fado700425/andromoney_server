class Record < ActiveRecord::Base
  self.table_name = "record_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
end
