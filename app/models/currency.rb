class Currency < ActiveRecord::Base
  self.table_name = "currency_table"
  validates_uniqueness_of :currency_code, scope: [ :user_id ]
  belongs_to :user
end
