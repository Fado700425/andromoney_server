class CategoriesController < ApplicationController
  def expense_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).not_hidden.each_slice(3).to_a
  end

  def income_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).not_hidden.each_slice(3).to_a
  end

  def transfer_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).not_hidden.each_slice(3).to_a
  end

  def index
    @expense_category = Category.where(type: 20, user_id: current_user.id).not_hidden
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}").not_hidden
    @transfer_category = Category.where(type: 30, user_id: current_user.id).not_hidden
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(3).to_a
  end

  def index_table_expense_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).not_hidden
    @category = Category.find_by(hash_key: params[:cateogry_hash], user_id: current_user.id)
  end

  def new
    @category = Category.new
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(8).to_a
  end

  def edit
    @category = Category.find(params[:id])
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(8).to_a
    @subcategories = Subcategory.where(id_category: @category.hash_key, user_id: current_user.id).not_hidden
  end

  def create
    category = Category.new(category_param)
    category.hidden = 0
    category.order_no = 1000
    category.hash_key = 
    category.device_uuid = "computer"
    category.update_time = DateTime.now.utc
    category.hash_key = SecureRandom.urlsafe_base64
    category.user_id = current_user.id
    if category.save
      params[:subcategorys].each do |sub|
        create_sub_category(category,sub["subcategory"])
      end
    end
    flash[:info] = "已成功新增類別！"
    redirect_to edit_category_path(category)
  end

  def update
    category = Category.find(params[:id])
    category.update(category_param)
    category.update_time = DateTime.now.utc
    category.device_uuid = "computer"
    category.save
    params[:subcategorys].each do |sub|
      if sub["subcategory_id"]
        sub_cat = Subcategory.find(sub["subcategory_id"])
        sub_cat.update_attribute(:subcategory,sub["subcategory"])
        sub_cat.update_time = DateTime.now.utc
        sub_cat.device_uuid = "computer"
        sub_cat.save
      else
        create_sub_category(category,sub["subcategory"])
      end
    end

    redirect_to edit_category_path(category)
  end

  def destroy
    binding.pry
  end

private
  def category_param
    params.require(:category).permit(:category,:photo_path,:type)
  end

  def create_sub_category category,subcategory
    sub_cat = Subcategory.new(subcategory: subcategory)
    sub_cat.id_category = category.hash_key
    sub_cat.hidden = 0
    sub_cat.order_no = 1000
    sub_cat.hash_key = SecureRandom.urlsafe_base64
    sub_cat.user_id = current_user.id
    sub_cat.update_time = DateTime.now.utc
    sub_cat.device_uuid = "computer"
    sub_cat.save
  end

end