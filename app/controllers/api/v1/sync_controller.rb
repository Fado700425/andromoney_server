class Api::V1::SyncController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def start
    params = deal_params
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    
    if (user && device)
      render :status=>200, :json=>{:message=>"Sync Start Success", :sync_start_time => user.sync_time}
      # if user.is_syncing && user.sync_time > Time.now - 10.minutes
      #   render :status=>403, :json=>{:message=>"User is syncing"}
      # else
      #   user.is_syncing = true
      #   user.sync_time = Time.now
      #   device.sync_start_time = Time.now
      #   device.is_syncing = true
      #   device.save
      #   user.save
      #   render :status=>200, :json=>{:message=>"Sync Start Success", :sync_start_time => user.sync_time}
      # end
    else
      render :status=>404, :json=>{:message=>"Start Fail, make sure db has user and device"}
    end
  end

  # def end
  #   params = deal_params
  #   user = User.find_by(email: params[:user])
  #   device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    
  #   if (user && device)
  #     if(user.is_syncing && device.is_syncing)
  #       user.is_syncing = false
  #       user.save
  #       device.is_syncing = false
  #       device.last_sync_time = Time.now
  #       device.save
  #       render :status=>200, :json=>{:message=>"Sync End Success", :sync_end_time => device.last_sync_time}
  #     else
  #       render :status=>403, :json=>{:message=>"User or Device is not syncing"}
  #     end
  #   else
  #     render :status=>404, :json=>{:message=>"End Fail, make sure db has user and device"}
  #   end
  # end

end