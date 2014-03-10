class Api::V1::SyncController < Api::V1::ApiController
  skip_before_filter  :verify_authenticity_token
  layout 'api'

  def start
    params = deal_params
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    
    if (user && device)
      sync_time = DateTime.now.utc
      render :status=>200, :json=>{:message=>"Sync Start Success", :sync_start_time => sync_time.strftime("%Y-%m-%d %H:%M:%S")}
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

  def owner_share_user_payment
    owner_user = User.find_by(email: params[:body][:owner_user])
    payment = Payment.find_by(user_id: owner_user.id, hash_key: params[:body][:payment_hash_key]) if owner_user

    if owner_user && payment
      share_user = User.find_by(email: params[:body][:share_user])
      share_user = User.create(email: params[:body][:share_user]) unless share_user
      relation = UserSharePaymentRelation.find_by(share_user_id: share_user.id, owner_user_id: owner_user.id, payment_hash_key: payment.hash_key)
      permission = params[:body][:permission] || UserSharePaymentRelation::READ
      relation = UserSharePaymentRelation.create(share_user_id: share_user.id, owner_user_id: owner_user.id, payment_hash_key: payment.hash_key, token: SecureRandom.urlsafe_base64, permission: permission) unless relation
      unless relation.new_record?
        SharePaymentMailer.delay.share_email(share_user, owner_user, payment, relation, params[:body][:locale])
        render :status=>200, :json=>{:message=>"Sync Requeset Success, owner: #{owner_user.email}, share_user: #{share_user.email}"}
      else
        render :status=>404, :json=>{:message=>"Sync Requeset Fail, can not create relation!"}
      end
    else
      render :status=>404, :json=>{:message=>"Sync Requeset Fail, data not find"}
    end
  end

  def delete_share
    owner_user = User.find_by(email: params[:body][:owner_user])
    share_user = User.find_by(email: params[:body][:share_user])
    payment = Payment.find_by(user_id: owner_user.id, hash_key: params[:body][:payment_hash_key])
    UserSharePaymentRelation.find_by(share_user_id: share_user.id, owner_user_id: owner_user.id, payment_hash_key: payment.hash_key).delete
    SharePaymentMailer.delay.owner_receive_delete_email(share_user, owner_user, payment, params[:body][:locale])
    SharePaymentMailer.delay.sharer_receive_delete_email(share_user, owner_user, payment, params[:body][:locale])
    render :status=>200, :json=>{:message=>"Sync Delete Share Success"}
  end

  def confirm_share
    @relation = UserSharePaymentRelation.find_by(token: params[:token])
    if @relation
      @relation.is_approved = true
      @relation.save
    else
      render :status=>404, :file => "#{Rails.root}/public/404"
    end
  end

  def is_pro
    user = User.find_by(email: params[:user])
    if user
      render :status=>200, :json=>{is_pro: user.is_pro, expire_date: user.expire_date}
    else
      render :status=>404, :json=>{:message=>"not find the user!"}
    end
  end

end