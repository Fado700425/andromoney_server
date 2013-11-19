class Api::V1::SyncController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def start
    params = deal_params
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    
    if (user && device)
      render :status=>200, :json=>{:message=>"Sync Start Success", :sync_start_time => Time.now}
    else
      render :status=>404, :json=>{:message=>"Start Fail, make sure db has user and device"}
    end
  end

end