class Payment < ActiveRecord::Base
  self.table_name = "payment_table"
  belongs_to :user
  validates_uniqueness_of :hash_key, scope: [ :user_id ]

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
end
