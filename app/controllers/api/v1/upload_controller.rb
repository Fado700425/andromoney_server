class Api::V1::UploadController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def record_table
    body_params = JSON.parse(params[:body].to_json,:symbolize_names => true)
    user = User.find_by(email: body_params[:user])
    device = Device.find_by(user_id: user.id, uuid: body_params[:device]) if user
    
    if user && device
      begin
        ActiveRecord::Base.transaction do
          insert_datas(body_params[:insert],"record",:hash_key,user,body_params[:device]) if body_params[:insert]
          update_datas(body_params[:update],"record",:hash_key,user,body_params[:device]) if body_params[:update]
          delete_datas(body_params[:delete],'record',:hash_key,user,body_params[:device]) if body_params[:delete]
        end
      rescue
        render :status=>404, :json=>{:message=>"Create Fail"}
        return false
      end

      render :status=>200, :json=>{:message=>"Create Success"}
    else
      render :status=>404, :json=>{:message=>"Create Fail"}
    end
  end

  def other_tables
    body_params = JSON.parse(params[:body].to_json,:symbolize_names => true)
    user = User.find_by(email: body_params[:user])
    device = Device.find_by(user_id: user.id, uuid: body_params[:device]) if user
    
    if user && device
      begin
        return unless create_all_data(user,body_params)
        return unless update_all_data(user,body_params)
        return unless delete_all_data(user,body_params)
      rescue
        render :status=>404, :json=>{:message=>"Create Fail"}
        return false
      end
      render :status=>200, :json=>{:message=>"Create Success"}
    else
      render :status=>404, :json=>{:message=>"Create Fail"}
    end
  end

private

  def create_all_data(user,params)

    begin
      ActiveRecord::Base.transaction do
        insert_datas(params[:category_table][:insert],"category", :hash_key,user,params[:device]) if params[:category_table]
        insert_datas(params[:payee_table][:insert],"payee", :hash_key,user,params[:device]) if params[:payee_table]
        insert_datas(params[:currency_table][:insert],"currency", :currency_code,user,params[:device]) if params[:currency_table]
        insert_datas(params[:payment_table][:insert],"payment", :hash_key,user,params[:device]) if params[:payment_table]
        insert_datas(params[:period_table][:insert],"period", :hash_key,user,params[:device]) if params[:period_table]
        insert_datas(params[:pref_table][:insert],"pref", :key,user,params[:device]) if params[:pref_table]
        insert_datas(params[:project_table][:insert],"project", :hash_key,user,params[:device]) if params[:project_table]
        insert_datas(params[:subcategory_table][:insert],"subcategory", :hash_key,user,params[:device]) if params[:subcategory_table]
      end
    rescue
      render :status=>404, :json=>{:message=>"Create Fail"}
      return false
    end
    return true
  end

  def update_all_data(user,params)
    device_uuid = params[:device]

    #logger.info "**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 

    begin
      ActiveRecord::Base.transaction do
        update_datas(params[:category_table][:update],"category",:hash_key,user,device_uuid) if params[:category_table]
        update_datas(params[:payee_table][:update],"payee",:hash_key,user,device_uuid) if params[:payee_table]
        update_datas(params[:currency_table][:update],"currency",:currency_code,user,device_uuid) if params[:currency_table]
        update_datas(params[:payment_table][:update],"payment",:hash_key,user,device_uuid) if params[:payment_table]
        update_datas(params[:period_table][:update],"period",:hash_key,user,device_uuid) if params[:period_table]
        update_datas(params[:pref_table][:update],"pref",:key,user,device_uuid) if params[:pref_table]
        update_datas(params[:project_table][:update],"project",:hash_key,user,device_uuid) if params[:project_table]
        update_datas(params[:subcategory_table][:update],"subcategory",:hash_key,user,device_uuid) if params[:subcategory_table]
      end
    rescue
      return false
    end
    return true
  end

  def delete_all_data(user,params)
    begin
      ActiveRecord::Base.transaction do
        delete_datas(params[:category_table][:delete],"category",:hash_key,user,params[:device]) if params[:category_table]
        delete_datas(params[:payee_table][:delete],"payee",:hash_key,user,params[:device]) if params[:payee_table]
        delete_datas(params[:currency_table][:delete],"currency",:currency_code,user,params[:device]) if params[:currency_table]
        delete_datas(params[:payment_table][:delete],"payment",:hash_key,user,params[:device]) if params[:payment_table]
        delete_datas(params[:period_table][:delete],"period",:hash_key,user,params[:device]) if params[:period_table]
        delete_datas(params[:pref_table][:delete],"pref",:key,user,params[:device]) if params[:pref_table]
        delete_datas(params[:project_table][:delete],"project",:hash_key,user,params[:device]) if params[:project_table]
        delete_datas(params[:subcategory_table][:delete],"subcategory",:hash_key,user,params[:device]) if params[:subcategory_table]
      end
    rescue
      return false
    end
    return true
  end

  def insert_datas(params,class_name,key,user,device_uuid)
    return unless params
    params.each do |param|
      begin
        param[:subcategory] = param.delete :sub_category if param.key?(:sub_category)
        param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
        param[:user_id] = user.id
        param[:device_uuid] = device_uuid
        data = eval(class_name.classify).create(param)
        update_existed_data(param,class_name,key,user,device_uuid) if data.new_record?
      rescue Exception => e
        logger.info "fail dddddddddddddddd"
        logger.info e
        logger.info e.backtrace
        logger.info param.to_json
        raise
      end
    end
  end

  def update_existed_data(param,class_name,key,user,device_uuid)
    data = eval(class_name.classify).find_by(key => param[key],user_id: user.id)
    param[:device_uuid] = device_uuid
    data.update_attributes(param) if data.update_time < param[:update_time]
  end

  def update_datas(params,class_name,key,user,device_uuid)
    return unless params
    params.each do |param|
      # logger.info "**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # Rails.logger.debug param.inspect
      # logger.info "**************************************************************************************************************************************************************************************************************fail dddddddddddddddd****************" 
      # Rails.logger.debug data.inspect
      # logger.info "－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－"
      # Rails.logger.debug param.inspect
      param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
      param[:is_delete] = false
      param[:device_uuid] = device_uuid
      param[:subcategory] = param.delete :sub_category if param.key?(:sub_category)
      data = eval(class_name.classify).find_by(key => param[key], user_id: user.id)
      data.update_attributes(param) if (data && data.update_time < param[:update_time])
    end
  end

  def delete_datas(params,class_name,key,user,device_uuid)
    return unless params
    params.each do |param|
      data = eval(class_name.classify).find_by(key => param[key], user_id: user.id)
      param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
      data.update_attributes(is_delete: true, update_time: param[:update_time],device_uuid: device_uuid) if (data && data.update_time < param[:update_time])
    end
  end

end