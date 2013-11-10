class Api::V1::UsersController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token

  def create
    Rails.logger.info("PARAMS: #{params.inspect}")
    params = deal_params
    user = User.new(email: params[:user])
    if user.save
      device = create_user_device(user,params)
      render :status=>200, :json=>{:message=>"Register Success"}
    else
      if user = User.find_by(email: params[:user])
        device = create_user_device(user,params)
        render :status=>304, :json=>{:message=>"Already Registered"}
      else
        render :status=>404, :json=>{:message=>"Register Fail"}
      end
    end
  end

  def is_user_register
    Rails.logger.info("PARAMS: #{params.inspect}")
    user = User.find_by(email: params[:user])
    if user
      render :status=>200, :json=> user.to_json
    else
      render :status=>404, :json=>{:message=>"Find User Fail"}
    end
  end


  private

  def create_user_device(user,params)
    device = user.devices.build
    device.uuid = params[:device]
    device.save
    device
  end

end