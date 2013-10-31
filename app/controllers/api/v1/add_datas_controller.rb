class Api::V1::AddDatasController < ApplicationController
  skip_before_filter  :verify_authenticity_token
  
  def create
    Rails.logger.info("PARAMS: #{params.inspect}")
    
    unless params[:body]
      render :status=>404, :json=>{:message=>"Create Fail"}
      return
    end
    
    body_params = JSON.parse(params[:body],:symbolize_names => true)
    user = User.find_by(email: body_params[:user])
    if user
      return unless create_all_data(user,body_params)
      render :status=>200, :json=>{:message=>"Create Success"}
    else
      render :status=>404, :json=>{:message=>"Create Fail"}
    end
  end

  private

  def insert_datas(params,user,class_name,key)
    params.each do |param|
      param[:update_time] = DateTime.parse(param[:update_time]) if param[:update_time]
      param[:user_id] = user.id
      data = eval(class_name.classify).create(param)
      update_existed_data(param,class_name,key,user) if data.new_record?
    end
  end

  def update_existed_data(param,class_name,key,user)
    data = eval(class_name.classify).find_by(key => param[key],user_id: user.id)
    data.update_attributes(param) if data.update_time < param[:update_time]
  end

  def create_all_data(user,params)

    begin
      ActiveRecord::Base.transaction do
        insert_datas(params[:record_table],user,"record", :hash_key) if params[:record_table]
        insert_datas(params[:category_table],user,"category", :hash_key) if params[:category_table]
        insert_datas(params[:payee_table],user,"payee", :hash_key) if params[:payee_table]
        insert_datas(params[:currency_table],user,"currency", :currency_code) if params[:currency_table]
        insert_datas(params[:payment_table],user,"payment", :hash_key) if params[:payment_table]
        insert_datas(params[:period_table],user,"period", :hash_key) if params[:period_table]
        insert_datas(params[:pref_table],user,"pref", :key) if params[:pref_table]
        insert_datas(params[:project_table],user,"project", :hash_key) if params[:project_table]
        insert_datas(params[:subcategory_table],user,"subcategory", :hash_key) if params[:subcategory_table]
      end
    rescue
      render :status=>404, :json=>{:message=>"Create Fail"}
      return false
    end
    return true
  end
end