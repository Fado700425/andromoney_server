class Api::V1::SyncController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def start
    params = deal_params
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    
    if (user && device)
      sync_time = Time.now.utc
      render :status=>200, :json=>{:message=>"Sync Start Success", :sync_start_time => sync_time}
    else
      render :status=>404, :json=>{:message=>"Start Fail, make sure db has user and device"}
    end
  end

  def end
    params = deal_params
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user

    if (user && device)
      sync_time = DateTime.parse(params[:sync_time])
      device.last_sync_time = sync_time
      device.save
      render :status=>200, :json=>{:message=>"Sync End Success, and update device last_sync_time"}
    else
      render :status=>404, :json=>{:message=>"End Fail, make sure db has user and device"}
    end

  end

end