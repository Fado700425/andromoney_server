class Api::V1::GetDeviceUpdateDatasController < ApplicationController
  def index
    user = User.find_by(email: params[:id])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    if user && device
      records = Record.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      categories = Category.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      payees = Payee.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      currencies = Currency.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      payments = Payment.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      periods = Period.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      prefs = Pref.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      projects = Project.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      subcategories = Subcategory.where(['updated_at > ? and user_id = ?', device.last_sync_time, user.id])
      render :status=>200, :json=>{records: records, categories: categories, payees: payees, currencies: currencies, payments: payments,periods: periods,prefs: prefs,projects: projects, subcategories: subcategories}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end