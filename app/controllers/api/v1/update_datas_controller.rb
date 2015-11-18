class Api::V1::UpdateDatasController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
  def update_all
    
    body_params = JSON.parse(params[:body].to_json,:symbolize_names => true)
    params = body_params

    user = User.find_by(email: params[:user])
    if user
      unless update_all_data(user,params)
        render :status=>404, :json=>{:message=>"Update Fail"}
        return
      end
      render :status=>200, :json=>{:message=>"Update Success"}
    else
      render :status=>404, :json=>{:message=>"Update Fail"}
    end
  end

  private

  def update_datas(params,class_name,key,user,device_uuid)
    params.each do |param|
      param[:subcategory] = param.delete :sub_category if param.key?(:sub_category)
      param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
      param[:is_delete] = false
      param[:device_uuid] = device_uuid
      data = eval(class_name.classify).find_by(key => param[key], user_id: user.id)
      data.update_attributes(param) if (data && data.update_time < param[:update_time])
    end
  end

  def update_all_data(user,params)
    device_uuid = params[:device]
    begin
      ActiveRecord::Base.transaction do
        update_datas(params[:record_table],"record",:hash_key,user,device_uuid) if params[:record_table]
        update_datas(params[:category_table],"category",:hash_key,user,device_uuid) if params[:category_table]
        update_datas(params[:payee_table],"payee",:hash_key,user,device_uuid) if params[:payee_table]
        update_datas(params[:currency_table],"currency",:currency_code,user,device_uuid) if params[:currency_table]
        update_datas(params[:payment_table],"payment",:hash_key,user,device_uuid) if params[:payment_table]
        update_datas(params[:period_table],"period",:hash_key,user,device_uuid) if params[:period_table]
        update_datas(params[:pref_table],"pref",:key,user,device_uuid) if params[:pref_table]
        update_datas(params[:project_table],"project",:hash_key,user,device_uuid) if params[:project_table]
        update_datas(params[:subcategory_table],"subcategory",:hash_key,user,device_uuid) if params[:subcategory_table]
      end
    rescue
      return false
    end
    return true
  end
end