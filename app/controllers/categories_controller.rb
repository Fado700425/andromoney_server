class CategoriesController < ApplicationController
  def expense_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).each_slice(3).to_a
  end

  def income_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).each_slice(3).to_a
  end

  def transfer_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).each_slice(3).to_a
  end

  def index
    @expense_category = Category.where(type: 20, user_id: current_user.id)
    @income_category = Category.where("type = 10 and hash_key != 'SYSTEM' and user_id = #{current_user.id}")
    @transfer_category = Category.where(type: 30, user_id: current_user.id)
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(3).to_a
  end

  def index_table_expense_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id)
    @category = Category.find_by(hash_key: params[:cateogry_hash], user_id: current_user.id)
  end

  def new
    @category = Category.new
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(8).to_a
  end

  def edit
    @category = Category.find(params[:id])
    @images = Dir.glob("app/assets/images/category_icon/*").each_slice(8).to_a
    @subcategories = Subcategory.where(id_category: @category.hash_key, user_id: current_user.id)
  end

  def create
    binding.pry
  end

  def update
    category = Category.find(params[:id])
    category.update(category_param)
    params[:subcategorys]
    
    # not finish

    redirect_to edit_category_path(category)
  end

  def destroy
    binding.pry
  end

private
  def category_param
    params.require(:category).permit(:category,:photo_path)
  end

end