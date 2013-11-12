class Period < ActiveRecord::Base
  self.table_name = "period_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  scope :api_select, -> { where(is_delete: false).select("id,start_date,end_date,update_date,period_type,period_num,order_no,hash_key,update_time"
                        ) }

  def as_json(options)
    json = super(:only => [:id,:period_type,:period_num,:order_no,:hash_key,:update_time])
    (start_date) ? json.merge!(start_date: start_date.strftime("%Y%m%d")) : json.merge!(start_date: nil) if attributes.include? "start_date"
    (end_date) ? json.merge!(end_date: start_date.strftime("%Y%m%d")) : json.merge!(end_date: nil) if attributes.include? "end_date"
    (update_date) ? json.merge!(update_date: start_date.strftime("%Y%m%d")) : json.merge!(update_date: nil) if attributes.include? "update_date"
    json
  end

end
