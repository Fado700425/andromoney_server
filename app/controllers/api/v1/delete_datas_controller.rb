class Api::V1::DeleteDatasController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def delete_all
    Rails.logger.info("PARAMS: #{params.inspect}")
    body_params = JSON.parse(params[:body],:symbolize_names => true)
    params = body_params
    user = User.find_by(email: params[:id])
    user = create_user_if_not_find_in_db(params) unless user
    
    if user && !user.new_record?
      update_device_sync_time(user,params)
      delete_all_data(user,params)
      render :status=>200, :json=>{:message=>"Delete Success"}
    else
      render :status=>404, :json=>{:message=>"Delete Fail"}
    end
  end


  private

  def create_user_if_not_find_in_db(params)
    email = params[:id]
    user = User.create(email: params[:id])    
  end

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

  def delete_all_data(user,params)
    if params[:record_table]
      records = Record.where(hash_key: params[:record_table].map{|p| p[:hash_key]})
      Record.where(id: records.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:category_table]
      categories = Category.where(hash_key: params[:category_table].map{|p| p[:hash_key]})
      Category.where(id: categories.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:payee_table]
      payees = Payee.where(hash_key: params[:payee_table].map{|p| p[:hash_key]})
      Payee.where(id: payees.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:currency_table]
      currencies = Currency.where(currency_code: params[:currency_table].map{|p| p[:currency_code]})
      Currency.where(id: currencies.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:payment_table]
      payments = Payment.where(hash_key: params[:payment_table].map{|p| p[:hash_key]})
      Payment.where(id: payments.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:period_table]
      periods = Period.where(hash_key: params[:period_table].map{|p| p[:hash_key]})
      Period.where(id: periods.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:pref_table]
      prefs = Pref.where(key: params[:pref_table].map{|p| p[:key]})
      Pref.where(id: prefs.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:project_table]
      projects = Project.where(hash_key: params[:project_table].map{|p| p[:hash_key]})
      Project.where(id: projects.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
    if params[:subcategory_table]
      subcategories = Subcategory.where(hash_key: params[:subcategory_table].map{|p| p[:hash_key]})
      Subcategory.where(id: subcategories.map(&:id), user_id: user.id).update_all(is_delete: true)
    end
  end
end
