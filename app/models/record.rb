class Record < ActiveRecord::Base
  self.table_name = "record_table"
  belongs_to :user

  # ===== validation =====
  validates :mount, presence: true, numericality: true
  validates :date, presence: true
  validates :category, presence: true
  validates :subcategory, presence: true
  validates :currency_code, presence: true
  validates :user_id, presence: true
  validates_uniqueness_of :hash_key,  scope: [ :user_id ]
  validate  :categoy_belongs_to_user
  validate  :category_type_fits_in_out_payment
  validate  :subcategory_belongs_to_category
  validate  :only_transfer_has_in_amount_currecny
  validate  :transfer_in_payment_out_payment_are_different

  # ===== scope =====
  scope :api_select, -> { where(is_delete: false).select("id,mount,category,subcategory,date, in_payment,out_payment,remark,currency_code,amount_to_main,period,
                              payee,project,fee,in_amount,out_amount,in_currency,out_currency,hash_key,update_time,receipt_num,status"
                        ) }
  scope :month_from_now, ->(num) { where("is_delete = false and date >= ? AND  date < ?", (Date.today + num.month).beginning_of_month, (Date.today + (num+1).month ).beginning_of_month) }
  scope :order_by_date, ->{order("date ASC")}
  scope :not_delete, -> {where(is_delete: false)}

  # ===== misc method =====
  #def category_order_num
  #  (category.split("_")[1].to_i*10 + category.split("_")[0].to_i) *1000 + (subcategory.split("_")[1].to_i*10 + subcategory.split("_")[0].to_i)
  #end

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
    Subcategory.find_by(user_id: user_id, hash_key: subcategory)
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

  # ===== validation method =====
  def categoy_belongs_to_user
    category = self.record_category
    if(!category)
      errors.add(:category, " TBD #{}")
    end
  end

  def category_type_fits_in_out_payment
    category_type = self.record_category.type if (self.record_category)
    has_in  = !self.in_payment.blank?
    has_out = !self.out_payment.blank?
    if    (category_type==10 &&  has_in && !has_out) #income has only in_payment.
    elsif (category_type==20 && !has_in &&  has_out) #expense has only out_payment.
    elsif (category_type==30 &&  has_in &&  has_out) #expense has in_payment and out_payment.
    else
      errors.add(:category, " TBD #{}")
    end
  end

  def subcategory_belongs_to_category
    category = self.record_category
    subcategory = self.record_subcategory
    category_find_by_subcategory = Category.find_by(user_id: user_id, hash_key: subcategory.id_category) if (category!=nil && subcategory!=nil)  # only dedicate to the case when :category, :subcategory are exist.
    if ( category != category_find_by_subcategory)
      errors.add(:subcategory, " TBD #{}")
    end
  end

  def only_transfer_has_in_amount_currecny
    is_transfer = self.in_payment && self.out_payment
    has_in_amount = !self.in_amount.blank?
    has_in_currency = !self.in_currency.blank?
    if    (  is_transfer &&  has_in_amount &&  has_in_currency )
    elsif ( !is_transfer && !has_in_amount && !has_in_currency )
    else
      errors.add(:in_amount, " TBD #{}")
    end
  end

  def transfer_in_payment_out_payment_are_different
    is_transfer = self.in_payment && self.out_payment

    if(is_transfer && (self.in_payment==self.out_payment))
      errors.add(:in_payment, " TBD #{}")
    end
  end

  # ===== json =====
  def as_json(options)
    json = super(:only => [:id,:mount,:category,:subcategory, :in_payment,:out_payment,:remark,:currency_code,:amount_to_main,:period,
                              :payee,:project,:fee,:in_amount,:out_amount,:in_currency,:out_currency,:hash_key,:update_time, :is_delete,:status,:receipt_num])

    json["subcategory"] = json.delete "subcategory"

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
