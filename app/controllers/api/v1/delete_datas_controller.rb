class Api::V1::DeleteDatasController < ApplicationController

  def destroy
    user = User.find_by(email: params[:id])
    if user
      delete_all_data(user,params)
      render :status=>200, :json=>{:message=>"Delete Success"}
    else
      render :status=>404, :json=>{:message=>"Delete Fail"}
    end
  end


  private

  def delete_all_data(user,params)
    if params[:records]
      records = Record.where(hash_key: params[:records].map{|p| p[:hash_key]})
      Record.where(id: records.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:categories]
      categories = Category.where(hash_key: params[:categories].map{|p| p[:hash_key]})
      Category.where(id: categories.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:payees]
      payees = Payee.where(hash_key: params[:payees].map{|p| p[:hash_key]})
      Payee.where(id: payees.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:currencies]
      currencies = Currency.where(currency_code: params[:currencies].map{|p| p[:currency_code]})
      Currency.where(id: currencies.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:payments]
      payments = Payment.where(hash_key: params[:payments].map{|p| p[:hash_key]})
      Payment.where(id: payments.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:periods]
      periods = Period.where(hash_key: params[:periods].map{|p| p[:hash_key]})
      Period.where(id: periods.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:prefs]
      prefs = Pref.where(key: params[:prefs].map{|p| p[:key]})
      Pref.where(id: prefs.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:projects]
      projects = Project.where(hash_key: params[:projects].map{|p| p[:hash_key]})
      Project.where(id: projects.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:subcategories]
      subcategories = Subcategory.where(hash_key: params[:subcategories].map{|p| p[:hash_key]})
      Subcategory.where(id: subcategories.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
  end
end
