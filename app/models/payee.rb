class Payee < ActiveRecord::Base
  self.table_name = "payee_table"
  self.inheritance_column = :_type_disabled
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  belongs_to :user
end
