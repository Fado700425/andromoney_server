class Api::V1::GetDeviceAddDatasController < ApplicationController
  def index
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    if user && device
      records = Record.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      categories = Category.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      payees = Payee.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      currencies = Currency.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      payments = Payment.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      periods = Period.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      prefs = Pref.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      projects = Project.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      subcategories = Subcategory.where(['created_at > ? and user_id = ?', device.last_sync_time, user.id])
      device.update_attribute(:last_sync_time, Time.now)
      render :status=>200, :json=>{records: records, categories: categories, payees: payees, currencies: currencies, payments: payments,periods: periods,prefs: prefs,projects: projects, subcategories: subcategories}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end