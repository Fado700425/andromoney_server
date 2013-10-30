class Pref < ActiveRecord::Base
  self.table_name = "pref_table"
  belongs_to :user
  validates_uniqueness_of :key, scope: [ :user_id ]

  scope :api_select, -> { select("id,key,value,update_time"
                        ) }
end
