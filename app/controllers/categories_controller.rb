class CategoriesController < ApplicationController
  def expense_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).each_slice(3).to_a
  end

  def income_subcategories
    @subcategories = Subcategory.where(id_category: params[:cateogry_hash], user_id: current_user.id).each_slice(3).to_a
  end
end