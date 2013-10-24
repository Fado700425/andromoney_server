class Api::V1::GetDeviceAddDatasController < ApplicationController
  def index
    user = User.find_by(email: params[:id])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user
    if user && device
      records = Record.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      categories = Category.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      payees = Payee.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      currencies = Currency.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      payments = Payment.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      periods = Period.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      prefs = Pref.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      projects = Project.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      subcategories = Subcategory.where(['created_at > ? and user_id = ?', DateTime.now, user.id])
      render :status=>200, :json=>{records: records, categories: categories, payees: payees, currencies: currencies, payments: payments,periods: periods,prefs: prefs,projects: projects, subcategories: subcategories}.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end