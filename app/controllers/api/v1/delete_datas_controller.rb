class Api::V1::DeleteDatasController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def delete_all
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    params = deal_params
    user = User.find_by(email: params[:user])
    
    if user && !user.new_record?
      update_device_sync_time(user,params)
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

  def update_device_sync_time(user,params)
    if params[:device]
      device = Device.find_by(user_id: user.id, uuid: params[:device])
      device = create_user_device(user,params) unless device
      device.sync_start_time = Time.now
      device.save
    end
  end

  def create_user_device(user,params)
    device = user.devices.build
    device.uuid = params[:device]
    device.save
    device
  end

  def delete_datas(params,class_name,key,user)
    params.each do |param|
      data = eval(class_name.classify).find_by(key => param[key], user_id: user.id)
      param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
      param[:is_delete] = true
      data.update_attributes(param) if data
    end
  end

  def delete_all_data(user,params)
    begin
      ActiveRecord::Base.transaction do
        delete_datas(params[:record_table],"record",:hash_key,user) if params[:record_table]
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
