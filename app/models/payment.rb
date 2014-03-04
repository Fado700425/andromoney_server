class Payment < ActiveRecord::Base
  self.table_name = "payment_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  validates_presence_of :payment_name

  default_scope { order('order_no desc') } 
  scope :not_hidden, ->{where("hidden = 0 and is_delete = 0")} 

  scope :api_select, -> { where(is_delete: false).select("id,kind,payment_name,total,currency_code,rate,out_total,hidden,order_no,hash_key,update_time"
                        ) }

  table_mapping =  {"record_table" => "Record", "category_table" => "Category", "payee_table" => "Payee", "currency_table" => "Currency", "payment_table" => "Payment", "period_table" => "Period", "pref_table" => "Pref", "project_table" => "Project", "subcategory_table" => "Subcategory"}


  def payment_related_datas(user_id, last_sync_time, page, per_page)
    records = Record.where("user_id = ? and (in_payment = ? or out_payment = ?) and updated_at > ?", user_id, hash_key, hash_key, last_sync_time).paginate(:page => page, :per_page => per_page)
    categories = Category.where("user_id = ? and hash_key in (?)", user_id, records.map(&:category))
    subcategories = Subcategory.where("user_id = ? and hash_key in (?)", user_id, records.map(&:sub_category))
    currencies = Currency.where("user_id = ? and (currency_code in (?) or sequence_status = 0)", user_id, records.map(&:currency_code))
    payees = Payee.where("user_id = ? and hash_key in (?)", user_id, records.map(&:payee))
    projects = Project.where("user_id = ? and hash_key in (?)", user_id, records.map(&:project))
    periods = Period.where("user_id = ? and hash_key in (?)", user_id, records.map(&:period))
    
    {
      total_pages: records.total_pages, 
      datas: {
        record_table: records,
        category_table: categories,
        payee_table: payees,
        currency_table: currencies,
        period_table: periods,
        project_table: projects,
        subcategory_table: subcategories
      }
    }
  end

  def display_currency_code(user)
    if init_record
      init_record.currency_code
    else
      user.get_main_currency.currency_code
    end
  end

  def init_record
    record = Record.find_by(in_payment: hash_key, category: "SYSTEM", sub_category: "INIT_AMOUNT", user_id: user_id, is_delete: 0)
  end

  def init_amount
    (init_record)? init_record.mount : 0
  end

  def income
    user = User.find(user_id)
    if display_currency_code(user) == user.get_main_currency.currency_code
      sum = Record.where(in_payment: hash_key, user_id: user_id).not_delete.sum("amount_to_main")
    else
      sum1 = Record.where(in_payment: hash_key, user_id: user_id, currency_code: init_record.currency_code).not_delete.sum("mount")
      sum2 = Record.where("in_payment = '#{hash_key}' and user_id = #{user_id} and currency_code != '#{init_record.currency_code}'").not_delete.sum("in_amount")
      sum = sum1 + sum2
    end
    (sum - init_amount).round(2)
  end

  def expense
    user = User.find(user_id)
    if display_currency_code(user) == user.get_main_currency.currency_code
      sum = Record.where(out_payment: hash_key, user_id: user_id).not_delete.sum("amount_to_main")
      sum.round(2)
    else
      sum1 = Record.where(out_payment: hash_key, user_id: user_id, currency_code: init_record.currency_code).not_delete.sum("mount")
      sum2 = Record.where("out_payment = '#{hash_key}' and user_id = #{user_id} and currency_code != '#{init_record.currency_code}'").not_delete.sum("out_amount")
      sum = sum1 + sum2
      sum.round(2)
    end
  end

  def exchange_rate
    if init_record
      payment_currency = Currency.find_by(currency_code: init_record.currency_code, user_id: user_id)
    else
      payment_currency = User.find(user_id).get_main_currency
    end
    main_currency = User.find(user_id).get_main_currency
    (main_currency.rate / payment_currency.rate).round(6)
  end

  def balance
    ((init_amount + income - expense) * exchange_rate).round(2)
  end
end
