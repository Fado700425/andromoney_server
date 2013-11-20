class Api::V1::GetDeviceDeleteDatasController < ApplicationController
  def index

    table_mapping =  {"record_table" => "Record", "category_table" => "Category", "payee_table" => "Payee", "currency_table" => "Currency", "payment_table" => "Payment", "period_table" => "Period", "pref_table" => "Pref", "project_table" => "Project", "subcategory_table" => "Subcategory"}

    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    if user && device
      sync_time = DateTime.parse(params[:sync_time])
      model = eval(table_mapping[params[:table]])
      datas = retreive_datas(sync_time, user, device, params,model)
      render :status=>200, :json=> {total_pages: datas.total_pages, datas: datas}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end

  def retreive_datas(sync_time, user, device, params,model)
    per_page = (params[:per_page])? (params[:per_page]) : 500
    if sync_time < device.last_sync_time
      case params[:table]
      when "currency_table"
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? ', sync_time, user.id,true]).select("currency_code").paginate(:page => params[:page], :per_page => per_page)
      when "pref_table"
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? ', sync_time, user.id,true]).select("pref_table.key").paginate(:page => params[:page], :per_page => per_page)
      else
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? ', sync_time, user.id,true]).select("hash_key").paginate(:page => params[:page], :per_page => per_page)
      end
    else
      case params[:table]
      when "currency_table"
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? and device_uuid != ?', sync_time, user.id,true, device.uuid]).select("currency_code").paginate(:page => params[:page], :per_page => per_page)
      when "pref_table"
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? and device_uuid != ?', sync_time, user.id,true, device.uuid]).select("pref_table.key").paginate(:page => params[:page], :per_page => per_page)
      else
        datas = model.where(['updated_at > ? and user_id = ? and is_delete = ? and device_uuid != ?', sync_time, user.id,true, device.uuid]).select("hash_key").paginate(:page => params[:page], :per_page => per_page)
      end
    end
    datas
  end
end