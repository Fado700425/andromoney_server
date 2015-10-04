class Category < ActiveRecord::Base
  self.table_name = "category_table"
  self.inheritance_column = :_type_disabled

  default_scope { order('order_no desc') }

  #scope :not_hidden, ->{where("category_table.hidden = 0 and category_table.is_delete = 0")} 
  scope :not_hidden, ->{where(is_delete: false, hidden: 0)} 
  
  belongs_to :user
  #has_many :subcategories, foreign_key: "id_category", primary_key: "hash_key"

  validates_uniqueness_of :hash_key, scope: [ :user_id ]
  scope :api_select, -> { where(is_delete: false).select("id,category,type,photo_path,hidden,order_no,hash_key,update_time"
                        ) }

  def get_subcategories		#method for record#new/edit view, grouped_collection_select.
    subcategories = Subcategory.where(user_id: self.user_id).where(id_category: self.hash_key).not_hidden.order(:order_no)
    return subcategories
  end

end
