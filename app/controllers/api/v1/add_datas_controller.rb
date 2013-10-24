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

  def create_all_data(user,params)

    begin
      ActiveRecord::Base.transaction do
    
        if params[:record_table]
          params[:record_table].each do |record_param|
            record = Record.new(record_param)
            record.user = user
            record.save
          end
        end

        if params[:category_table]
          params[:category_table].each do |cat_param|
            cat_param[:update_time] = DateTime.parse(cat_param[:update_time])
            cat_param[:user_id] = user.id
          end
          Category.create(params[:category_table])
        end

        if params[:payee_table]
          params[:payee_table].each do |payee_param|
            payee = Payee.new(payee_param)
            payee.user = user
            payee.save
          end
        end

        if params[:currency_table]
          params[:currency_table].each do |currency_param|
            currency = Currency.new(currency_param)
            currency.user = user
            currency.save
          end
        end

        if params[:payment_table]
          params[:payment_table].each do |payment_param|
            payment = Payment.new(payment_param)
            payment.user = user
            payment.save
          end
        end

        if params[:period_table]
          params[:period_table].each do |period_param|
            period = Period.new(period_param)
            period.user = user
            period.save
          end
        end

        if params[:pref_table]
          params[:pref_table].each do |pref_param|
            pref = Pref.new(pref_param)
            pref.user = user
            pref.save
          end
        end

        if params[:project_table]
          params[:project_table].each do |project_param|
            project = Project.new(project_param)
            project.user = user
            project.save
          end
        end

        if params[:subcategory_table]
          params[:subcategory_table].each do |subcategory_param|
            subcategory_param[:user_id] = user.id
          end
          Subcategory.create(params[:subcategory_table])
        end
      end
    rescue
      render :status=>404, :json=>{:message=>"Create Fail"}
      return false
    end
    return true
  end
end