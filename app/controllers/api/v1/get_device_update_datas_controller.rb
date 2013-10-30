class Api::V1::GetDeviceUpdateDatasController < ApplicationController
  def index

    table_mapping =  {"record_table" => "Record", "category_table" => "Category", "payee_table" => "Payee", "currency_table" => "Currency", "payment_table" => "Payment", "period_table" => "Period", "pref_table" => "Pref", "project_table" => "Project", "subcategory_table" => "Subcategory"}
    
    user = User.find_by(email: params[:user])
    device = Device.find_by(user_id: user.id, uuid: params[:device]) if user

    if user && device
      sync_time = DateTime.parse(params[:sync_time])
      model = eval(table_mapping[params[:table]])
      datas = model.where(['updated_at > ? and user_id = ?', sync_time, user.id])
      render :status=>200, :json=> datas.to_json
    else
      render :status=>404, :json=>{:message=>"get Fail"}
    end
  end
end