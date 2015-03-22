class Record < ActiveRecord::Base
  self.table_name = "record_table"
  belongs_to :user
  validates_presence_of :date
  validates_uniqueness_of :hash_key,  scope: [ :user_id ]


  scope :api_select, -> { where(is_delete: false).select("id,mount,category,sub_category,date, in_payment,out_payment,remark,currency_code,amount_to_main,period,
                              payee,project,fee,in_amount,out_amount,in_currency,out_currency,hash_key,update_time,status"
                        ) }

  scope :month_from_now, ->(num) { where("is_delete = false and date > ? AND  date < ?", (Time.now + num.month).beginning_of_month, (Time.now + num.month).end_of_month) }

  scope :order_by_date, ->{order("date ASC")}

  scope :not_delete, -> {where(is_delete: false)}

  def category_order_num
    (category.split("_")[1].to_i*10 + category.split("_")[0].to_i) *1000 + (sub_category.split("_")[1].to_i*10 + sub_category.split("_")[0].to_i)
  end

  def calculate_record_amount(currency)
    return nil unless mount
    return mount if currency.currency_code == record_currency.currency_code
    mount * currency.rate / record_currency.rate
  end

  def record_currency
    Currency.find_by(user_id: user_id, currency_code: currency_code)
  end

  def record_category
    Category.find_by(user_id: user_id, hash_key: category)
  end

  def record_subcategory
    Subcategory.find_by(user_id: user_id, hash_key: sub_category)
  end

  def record_project
    Project.find_by(user_id: user_id, hash_key: project)
  end

  def record_payee
    Payee.find_by(user_id: user_id, hash_key: payee)
  end

  def record_period
    Period.find_by(user_id: user_id, hash_key: period)
  end

  def record_out_payment
    Payment.find_by(user_id: user_id, hash_key: out_payment)
  end

  def record_in_payment
    Payment.find_by(user_id: user_id, hash_key: in_payment)
  end

  def as_json(options)
    json = super(:only => [:id,:mount,:category,:sub_category, :in_payment,:out_payment,:remark,:currency_code,:amount_to_main,:period,
                              :payee,:project,:fee,:in_amount,:out_amount,:in_currency,:out_currency,:hash_key,:update_time, :is_delete,:status])

    if attributes.include? "date"
      if(date)
        json.merge!(date: date.strftime("%Y%m%d")) 
        record_time=date.strftime("%H%M")
        json.merge!(record_time: record_time) if record_time!="0000" 
      else
         json.merge!(date: nil) if attributes.include? "date"
      end
    end


    json
  end
end
