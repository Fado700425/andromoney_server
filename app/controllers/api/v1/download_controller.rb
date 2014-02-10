class Api::V1::DownloadController < ApplicationController
  def record_table
    per_page = (params[:per_page])? (params[:per_page]) : 500
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user

    if user && device
      sync_time = DateTime.parse(params[:sync_time])
      if sync_time < device.last_sync_time || sync_time <= DateTime.parse('2000-01-01 00:00:00')
        update_datas = Record.where(['updated_at > ? and user_id = ?', sync_time, user.id]).api_select.paginate(:page => params[:page], :per_page => per_page)
        delete_datas = Record.where(['updated_at > ? and user_id = ? and is_delete = ? ', sync_time, user.id,true]).select("hash_key").paginate(:page => params[:page], :per_page => per_page)
      else
        update_datas = Record.where(['updated_at > ? and user_id = ? and device_uuid != ?', sync_time, user.id, device.uuid]).api_select.paginate(:page => params[:page], :per_page => per_page)
        delete_datas = Record.where(['updated_at > ? and user_id = ? and is_delete = ? and device_uuid != ?', sync_time, user.id,true, device.uuid]).select("hash_key").paginate(:page => params[:page], :per_page => per_page)
      end

      total_pages = (update_datas.total_pages > delete_datas.total_pages)? update_datas.total_pages : delete_datas.total_pages

      render :status=>200, :json=> {total_pages: total_pages, update: update_datas, delete: delete_datas}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end

  def other_tables

  end
end