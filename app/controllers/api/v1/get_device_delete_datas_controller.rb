class Api::V1::GetDeviceDeleteDatasController < ApplicationController
  def index
    user = User.find_by(email: params[:id])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    if user && device
      records = Record.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      categories = Category.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      payees = Payee.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      currencies = Currency.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("currency_code")
      payments = Payment.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      periods = Period.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      prefs = Pref.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("key")
      projects = Project.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      subcategories = Subcategory.where(['updated_at > ? and user_id = ? and is_delete = ?', device.last_sync_time, user.id,true]).select("hash_key")
      render :status=>200, :json=>{records: records, categories: categories, payees: payees, currencies: currencies, payments: payments,periods: periods,prefs: prefs,projects: projects, subcategories: subcategories}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end