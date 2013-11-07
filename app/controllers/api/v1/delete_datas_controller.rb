class Api::V1::DeleteDatasController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def delete_all
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    params = deal_params
    user = User.find_by(email: params[:user])
    
    if user && !user.new_record?
      unless delete_all_data(user,params)
        render :status=>404, :json=>{:message=>"Create Fail"}
        return
      end
      render :status=>200, :json=>{:message=>"Delete Success"}
    else
      render :status=>404, :json=>{:message=>"Delete Fail"}
    end
  end


  private

  def delete_datas(params,class_name,key,user)
    datas = eval(class_name.classify).where(key => params.map{|p| p[key]}).select('id')
    eval(class_name.classify).where(id: datas.map(&:id),user_id: user.id).update_all(is_delete: true, updated_at: Time.now,update_time: Time.now)
  end

  def delete_all_data(user,params)
    begin
      ActiveRecord::Base.transaction do
        delete_datas(params[:record_table],'record',:hash_key,user) if params[:record_table]
        delete_datas(params[:category_table],"category",:hash_key,user) if params[:category_table]
        delete_datas(params[:payee_table],"payee",:hash_key,user) if params[:payee_table]
        delete_datas(params[:currency_table],"currency",:currency_code,user) if params[:currency_table]
        delete_datas(params[:payment_table],"payment",:hash_key,user) if params[:payment_table]
        delete_datas(params[:period_table],"period",:hash_key,user) if params[:period_table]
        delete_datas(params[:pref_table],"pref",:key,user) if params[:pref_table]
        delete_datas(params[:project_table],"project",:hash_key,user) if params[:project_table]
        delete_datas(params[:subcategory_table],"subcategory",:hash_key,user) if params[:subcategory_table]
      end
    rescue
      return false
    end
    return true
  end
end
